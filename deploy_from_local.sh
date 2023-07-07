#!/bin/bash

while getopts ":n:de:kh" opt; do
  case $opt in
    n)
      export NAMESPACE=$OPTARG
      echo "Selected namespace: $NAMESPACE" >&2
      ;;
    d)
      DRYRUN=1
      echo "Dry-run enabled. No file will be applied"
      ;;
    e)
      case $OPTARG in 
        dev)
          export LOWERCASE_ENV=dev
          export CONFIG_FILE='./kubernetes/configs/dev/main.sh'
          ;;
        test)
          export LOWERCASE_ENV=test
          export CONFIG_FILE='./kubernetes/configs/test/main.sh'
          ;;
        prod)
          export LOWERCASE_ENV=prod
          export CONFIG_FILE='./kubernetes/configs/prod/main.sh'
          ;;
        \?)
          echo "Invalid environment: -$OPTARG" >&2
          exit 1
          ;;
      esac
      echo "Selected environment: $OPTARG" >&2
      ;;
    k)
      KEEPFILES=1
      echo "Generated files will not be deleted"
      ;;
    h)
      echo "Usage $0 -n namespace [-d]"
      echo " -d dry-run: Creates files and print commands without executing them"
      echo " -k keep files: Generated files will not be deleted"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ -z ${NAMESPACE} ]; then 
  echo "Namespace parameter is mandatory"
  exit 1
fi

if [ -z ${LOWERCASE_ENV} ]; then 
  echo "Environment parameter is mandatory"
  exit 1
fi

source $CONFIG_FILE

# Params:
#   dirPath
#   serviceName
#   imageVersion
#   serviceImageDigest
function compileDir() {
    dirPath=$1
    serviceName=$2
    imageVersion=$3
    serviceImageDigest=$4
    resourceCpu=$5
    resourceMem=$6

    eval $(source ./${LOWERCASE_ENV}-secrets; echo awsAccountId=$AWS_ACCOUNT_ID)

    for f in $dirPath/*
    do
        if [ ! $(basename $f) = "kustomization.yaml" ]
        then
            mkdir -p $serviceName/$dirPath
            SERVICE_NAME=$serviceName \
            IMAGE_VERSION=$imageVersion \
            IMAGE_DIGEST=$serviceImageDigest \
            SERVICE_RESOURCE_CPU=${resourceCpu} \
            SERVICE_RESOURCE_MEM=${resourceMem} \
            AWS_ACCOUNT_ID=$awsAccountId \
            kubernetes/templater.sh $f -s -f $CONFIG_FILE > $serviceName/$f
        else
            cp $f $serviceName/$f
        fi
    done
}

# Params:
#   dirPath
#   serviceName
#   imageVersion
function applyKustomizeToDir() {
    dirPath=$1
    serviceName=$2
    imageVersion=$3
    resourceCpu=$4
    resourceMem=$5

    echo "********** ${serviceName} **********"
    echo "Apply directory ${dirPath} on Kubernetes"

    serviceImageDigest=$(getDockerImageDigest $serviceName $imageVersion)

    kubeDirPath='kubernetes/'$dirPath

    echo "Compiling base files"
    compileDir "kubernetes/base" $serviceName $imageVersion $serviceImageDigest $resourceCpu $resourceMem
    echo "Base files compiled"

    echo "Compiling common files"
    compileDir "kubernetes/commons/database" $serviceName $imageVersion $serviceImageDigest $resourceCpu $resourceMem
    compileDir "kubernetes/commons/rate-limiting" $serviceName $imageVersion $serviceImageDigest $resourceCpu $resourceMem
    echo "Common files compiled"

    echo "Compiling directory ${dirPath}"
    compileDir $kubeDirPath $serviceName $imageVersion $serviceImageDigest $resourceCpu $resourceMem
    echo "Directory ${dirPath} compiled"
    
    echo "Applying Kustomization for ${serviceName}"
    kubectl kustomize --load-restrictor LoadRestrictionsNone $serviceName/$kubeDirPath > $serviceName/full.${serviceName}.yaml
    echo "Kustomization for ${serviceName} applied"

    kubeApply ${serviceName}/full.${serviceName}.yaml
    cleanFiles ${serviceName}

    echo "************************************"
}


function applyKubeFile() {
    fileName=$1
    serviceName=$2
    imageDigest=$3
    resourceCpu=$4
    resourceMem=$5

    echo "Apply file ${fileName} on Kubernetes"

    eval $(source ./${LOWERCASE_ENV}-secrets; echo awsAccountId=$AWS_ACCOUNT_ID)

    echo "Compiling file ${fileName}"
    SERVICE_NAME=${serviceName} \
    IMAGE_DIGEST=${imageDigest} \
    AWS_ACCOUNT_ID=$awsAccountId \
    SERVICE_RESOURCE_CPU=${resourceCpu} \
    SERVICE_RESOURCE_MEM=${resourceMem} \
    ./kubernetes/templater.sh ./kubernetes/${fileName} \
    -s \
    -f ${CONFIG_FILE} > ./kubernetes/$(dirname $fileName)/compiled.$(basename $fileName)
    echo "File ${fileName} compiled"
    
    kubeApply ./kubernetes/$(dirname $fileName)/compiled.$(basename $fileName)
    cleanFiles ./kubernetes/$(dirname $fileName)/compiled.$(basename $fileName)
}


function prepareDbMigrations() {
    echo "********** DB Migrations **********"

    echo 'Creating migrations configmap...'
    outputFileName='./kubernetes/compiled.dbmigrationconfigmap.yaml'
    kubectl \
        create configmap common-db-migrations \
        --namespace $NAMESPACE \
        --from-file=db/migrations/ \
        --dry-run=client \
        -o yaml > $outputFileName
        
    kubeApply $outputFileName
    cleanFiles $outputFileName

    echo 'Migrations configmap created'

    echo "***********************************"
}


function createReadModelUser() {
    user=$1
    password=$2
    role=$3
    
    echo "********** MongoDB User Creation **********"

    echo "Creating user in read model..."
    encodedAdminUser=$(urlEncode $READ_MODEL_CREDENTIALS_ADMIN_USR)
    encodedAdminPassword=$(urlEncode $READ_MODEL_CREDENTIALS_ADMIN_PSW)
    encodedNewUser=$(urlEncode $user)
    encodedNewPassword=$(urlEncode $password)

    if [ -z ${DRYRUN} ]; then 
      mongosh "mongodb://$encodedAdminUser:$encodedAdminPassword@$READ_MODEL_DB_HOST:$READ_MODEL_DB_PORT/admin" \
          --eval "if(db.getUser("$encodedNewUser") == null) { db.createUser({
            user: "$encodedNewUser",
            pwd: "$encodedNewPassword",
            roles: [ {role: "$role", db: "$READ_MODEL_DB_NAME"} ]
          })}"
    fi

    echo "User created in read model"
    echo "*******************************************"

}

function urlEncode() {
    echo "$@" \
    | sed \
        -e 's/%/%25/g' \
        -e 's/ /%20/g' \
        -e 's/!/%21/g' \
        -e 's/"/%22/g' \
        -e "s/'/%27/g" \
        -e 's/#/%23/g' \
        -e 's/(/%28/g' \
        -e 's/)/%29/g' \
        -e 's/+/%2b/g' \
        -e 's/,/%2c/g' \
        -e 's/-/%2d/g' \
        -e 's/:/%3a/g' \
        -e 's/;/%3b/g' \
        -e 's/?/%3f/g' \
        -e 's/@/%40/g' \
        -e 's/\$/%24/g' \
        -e 's/\&/%26/g' \
        -e 's/\*/%2a/g' \
        -e 's/\./%2e/g' \
        -e 's/\//%2f/g' \
        -e 's/\[/%5b/g' \
        -e 's/\\/%5c/g' \
        -e 's/\]/%5d/g' \
        -e 's/\^/%5e/g' \
        -e 's/_/%5f/g' \
        -e 's/`/%60/g' \
        -e 's/{/%7b/g' \
        -e 's/|/%7c/g' \
        -e 's/}/%7d/g' \
        -e 's/~/%7e/g'
}

function getDockerImageDigest() {
    serviceName=$1
    imageVersion=$2
    
    # echo "Retrieving digest for service ${serviceName} and version ${imageVersion}..."

    sha256=$(docker manifest inspect $REPOSITORY/$serviceName:$imageVersion | jq .config.digest)

    # echo "Digest retrieved for service ${serviceName} and version ${imageVersion}: ${sha256}"

    echo $sha256
}

function loadSecret() {
    secretName=$1

    outputFileName="./kubernetes/compiled.secret.$secretName.yaml"

    shift
    tuples=("${@}")
    length=${#tuples[@]}

    header="kubectl -n $NAMESPACE create secret generic ${secretName} --save-config --dry-run=client "
    command=$header

    for (( j=0; j<length; j=j+2 ));
    do
    i=$j
    k=$((j+1))
    command="$command--from-literal=${tuples[$i]}=\${${tuples[$k]}} "
    done

    command="$command -o yaml > $outputFileName"
    eval $command

    kubeApply $outputFileName
    cleanFiles $outputFileName
}

function loadSecrets() {
    echo "********** Secrets **********"

    source ./${LOWERCASE_ENV}-secrets
    loadSecret 'user-registry' 'USER_REGISTRY_API_KEY' 'USER_REGISTRY_API_KEY'
    loadSecret 'party-process' 'PARTY_PROCESS_API_KEY' 'PARTY_PROCESS_API_KEY'
    loadSecret 'party-management' 'PARTY_MANAGEMENT_API_KEY' 'PARTY_MANAGEMENT_API_KEY'
    loadSecret 'selfcare-v2' 'SELFCARE_V2_API_KEY' 'SELFCARE_V2_API_KEY'
    loadSecret 'postgres' 'POSTGRES_USR' 'POSTGRES_CREDENTIALS_USR' 'POSTGRES_PSW' 'POSTGRES_CREDENTIALS_PSW'
    loadSecret 'documentdb' 'PROJECTION_USR' 'READ_MODEL_CREDENTIALS_PROJECTION_USR' 'PROJECTION_PSW' 'READ_MODEL_CREDENTIALS_PROJECTION_PSW' 'READONLY_USR' 'READ_MODEL_CREDENTIALS_RO_USR' 'READONLY_PSW' 'READ_MODEL_CREDENTIALS_RO_PSW'
    loadSecret 'onetrust' 'ONETRUST_CLIENT_ID' 'ONETRUST_CLIENT_ID' 'ONETRUST_CLIENT_SECRET' 'ONETRUST_CLIENT_SECRET'

    echo "*****************************"
}

function createIngress() {
    echo "********** Ingress **********"

    tuples=("${@}")
    length=${#tuples[@]}

    outputFileName='./kubernetes/compiled.ingress.yaml'

    baseCommand="kubectl -n $NAMESPACE create ingress interop-services --class=alb --dry-run=client -o yaml "
    annotations='--annotation="alb.ingress.kubernetes.io/scheme=internal" --annotation="alb.ingress.kubernetes.io/target-type=ip" '

    rules=''

    for (( j=0; j<length; j=j+3 ));
    do
    i=$j
    k=$((j+1))
    z=$((j+2))
    rules=$rules' --rule="/'${tuples[$k]}'*='${tuples[$i]}':'${tuples[$z]}'" '
    done

    eval "$baseCommand $annotations $rules > $outputFileName"

    kubeApply $outputFileName
    cleanFiles $outputFileName

    echo "*****************************"
}

function kubeApply() {
    yamlFileNameForKubeApply=$1
    if [ -z ${DRYRUN} ]; then 
        echo "Applying $yamlFileNameForKubeApply"
        kubectl apply -f $yamlFileNameForKubeApply
        echo "Applied: $yamlFileNameForKubeApply"
    fi
}

function cleanFiles() {
    pathDoTelete=$1
    if [ -z ${KEEPFILES} ]; then 
        rm -rf $pathDoTelete
        echo "Deleted: $pathDoTelete"
    fi
}

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REPOSITORY 2>/dev/null 1>&2;
echo "Logged on ECR"

# applyKubeFile 'namespace.yaml'
loadSecrets
prepareDbMigrations


applyKubeFile 'frontend/configmap.yaml' $FRONTEND_SERVICE_NAME
frontendImageDigest=$(getDockerImageDigest $FRONTEND_SERVICE_NAME $FRONTEND_IMAGE_VERSION)
applyKubeFile 'frontend/deployment.yaml' $FRONTEND_SERVICE_NAME $frontendImageDigest $FRONTEND_RESOURCE_CPU $FRONTEND_RESOURCE_MEM
applyKubeFile 'frontend/service.yaml' $FRONTEND_SERVICE_NAME

applyKustomizeToDir 'overlays/agreement-management' $AGREEMENT_MANAGEMENT_SERVICE_NAME $AGREEMENT_MANAGEMENT_IMAGE_VERSION $AGREEMENT_MANAGEMENT_RESOURCE_CPU $AGREEMENT_MANAGEMENT_RESOURCE_MEM
applyKustomizeToDir 'overlays/agreement-process' $AGREEMENT_PROCESS_SERVICE_NAME $AGREEMENT_PROCESS_IMAGE_VERSION $AGREEMENT_PROCESS_RESOURCE_CPU $AGREEMENT_PROCESS_RESOURCE_MEM
applyKustomizeToDir 'overlays/attribute-registry-management' $ATTRIBUTE_REGISTRY_MANAGEMENT_SERVICE_NAME $ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION $ATTRIBUTE_REGISTRY_MANAGEMENT_RESOURCE_CPU $ATTRIBUTE_REGISTRY_MANAGEMENT_RESOURCE_MEM
applyKustomizeToDir 'overlays/attribute-registry-process' $ATTRIBUTE_REGISTRY_PROCESS_SERVICE_NAME $ATTRIBUTE_REGISTRY_PROCESS_IMAGE_VERSION $ATTRIBUTE_REGISTRY_PROCESS_RESOURCE_CPU $ATTRIBUTE_REGISTRY_PROCESS_RESOURCE_MEM
applyKustomizeToDir 'overlays/authorization-management' $AUTHORIZATION_MANAGEMENT_SERVICE_NAME $AUTHORIZATION_MANAGEMENT_IMAGE_VERSION $AUTHORIZATION_MANAGEMENT_RESOURCE_CPU $AUTHORIZATION_MANAGEMENT_RESOURCE_MEM
applyKustomizeToDir 'overlays/authorization-process' $AUTHORIZATION_PROCESS_SERVICE_NAME $AUTHORIZATION_PROCESS_IMAGE_VERSION $AUTHORIZATION_PROCESS_RESOURCE_CPU $AUTHORIZATION_PROCESS_RESOURCE_MEM
applyKustomizeToDir 'overlays/authorization-server' $AUTHORIZATION_SERVER_SERVICE_NAME $AUTHORIZATION_SERVER_IMAGE_VERSION $AUTHORIZATION_SERVER_RESOURCE_CPU $AUTHORIZATION_SERVER_RESOURCE_MEM
applyKustomizeToDir 'overlays/catalog-management' $CATALOG_MANAGEMENT_SERVICE_NAME $CATALOG_MANAGEMENT_IMAGE_VERSION $CATALOG_MANAGEMENT_RESOURCE_CPU $CATALOG_MANAGEMENT_RESOURCE_MEM
applyKustomizeToDir 'overlays/catalog-process' $CATALOG_PROCESS_SERVICE_NAME $CATALOG_PROCESS_IMAGE_VERSION $CATALOG_PROCESS_RESOURCE_CPU $CATALOG_PROCESS_RESOURCE_MEM
applyKustomizeToDir 'overlays/party-registry-proxy' $PARTY_REGISTRY_PROXY_SERVICE_NAME $PARTY_REGISTRY_PROXY_IMAGE_VERSION $PARTY_REGISTRY_PROXY_RESOURCE_CPU $PARTY_REGISTRY_PROXY_RESOURCE_MEM
applyKustomizeToDir 'overlays/purpose-management' $PURPOSE_MANAGEMENT_SERVICE_NAME $PURPOSE_MANAGEMENT_IMAGE_VERSION $PURPOSE_MANAGEMENT_RESOURCE_CPU $PURPOSE_MANAGEMENT_RESOURCE_MEM
applyKustomizeToDir 'overlays/purpose-process' $PURPOSE_PROCESS_SERVICE_NAME $PURPOSE_PROCESS_IMAGE_VERSION $PURPOSE_PROCESS_RESOURCE_CPU $PURPOSE_PROCESS_RESOURCE_MEM
applyKustomizeToDir 'overlays/tenant-management' $TENANT_MANAGEMENT_SERVICE_NAME $TENANT_MANAGEMENT_IMAGE_VERSION $TENANT_MANAGEMENT_RESOURCE_CPU $TENANT_MANAGEMENT_RESOURCE_MEM
applyKustomizeToDir 'overlays/tenant-process' $TENANT_PROCESS_SERVICE_NAME $TENANT_PROCESS_IMAGE_VERSION $TENANT_PROCESS_RESOURCE_CPU $TENANT_PROCESS_RESOURCE_MEM

applyKustomizeToDir 'overlays/backend-for-frontend' $BACKEND_FOR_FRONTEND_SERVICE_NAME $BACKEND_FOR_FRONTEND_IMAGE_VERSION $BACKEND_FOR_FRONTEND_RESOURCE_CPU $BACKEND_FOR_FRONTEND_RESOURCE_MEM
applyKustomizeToDir 'overlays/api-gateway' $API_GATEWAY_SERVICE_NAME $API_GATEWAY_IMAGE_VERSION $API_GATEWAY_RESOURCE_CPU $API_GATEWAY_RESOURCE_MEM
applyKustomizeToDir 'overlays/notifier' $NOTIFIER_SERVICE_NAME $NOTIFIER_IMAGE_VERSION $NOTIFIER_RESOURCE_CPU $NOTIFIER_RESOURCE_MEM

applyKubeFile 'jobs/attributes-loader/configmap.yaml' $JOB_ATTRIBUTES_LOADER_SERVICE_NAME
applyKubeFile 'jobs/attributes-loader/serviceaccount.yaml' $JOB_ATTRIBUTES_LOADER_SERVICE_NAME
attributesLoaderImageDigest=$(getDockerImageDigest $JOB_ATTRIBUTES_LOADER_SERVICE_NAME $JOB_ATTRIBUTES_LOADER_IMAGE_VERSION)
applyKubeFile 'jobs/attributes-loader/cronjob.yaml' $JOB_ATTRIBUTES_LOADER_SERVICE_NAME $attributesLoaderImageDigest $JOB_ATTRIBUTES_LOADER_RESOURCE_CPU $JOB_ATTRIBUTES_LOADER_RESOURCE_MEM

applyKubeFile 'jobs/token-details-persister/configmap.yaml' $JOB_DETAILS_PERSISTER_SERVICE_NAME
applyKubeFile 'jobs/token-details-persister/serviceaccount.yaml' $JOB_DETAILS_PERSISTER_SERVICE_NAME
jobDetailsPersisterImageDigest=$(getDockerImageDigest $JOB_DETAILS_PERSISTER_SERVICE_NAME $JOB_DETAILS_PERSISTER_IMAGE_VERSION)
applyKubeFile 'jobs/token-details-persister/cronjob.yaml' $JOB_DETAILS_PERSISTER_SERVICE_NAME $jobDetailsPersisterImageDigest $JOB_DETAILS_PERSISTER_RESOURCE_CPU $JOB_DETAILS_PERSISTER_RESOURCE_MEM

applyKubeFile 'jobs/tenants-certified-attributes-updater/configmap.yaml' $JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_SERVICE_NAME
applyKubeFile 'jobs/tenants-certified-attributes-updater/serviceaccount.yaml' $JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_SERVICE_NAME
jobTenantsCertAttrUpdaterImageDigest=$(getDockerImageDigest $JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_SERVICE_NAME $JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_VERSION)
applyKubeFile 'jobs/tenants-certified-attributes-updater/cronjob.yaml' $JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_SERVICE_NAME $jobTenantsCertAttrUpdaterImageDigest $JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_RESOURCE_CPU $JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_RESOURCE_MEM

applyKubeFile 'thirdparty/party-registry-proxy-refresher/configmap.yaml' $JOB_PARTY_REGISTRY_PROXY_REFRESHER_SERVICE_NAME
applyKubeFile 'thirdparty/party-registry-proxy-refresher/serviceaccount.yaml' $JOB_PARTY_REGISTRY_PROXY_REFRESHER_SERVICE_NAME
applyKubeFile 'thirdparty/party-registry-proxy-refresher/cronjob.yaml' $JOB_PARTY_REGISTRY_PROXY_REFRESHER_SERVICE_NAME "fixed" $JOB_PARTY_REGISTRY_PROXY_REFRESHER_RESOURCE_CPU $JOB_PARTY_REGISTRY_PROXY_REFRESHER_RESOURCE_MEM

applyKubeFile 'jobs/metrics-report-generator/configmap.yaml' $JOB_METRICS_REPORT_GENERATOR_SERVICE_NAME
applyKubeFile 'jobs/metrics-report-generator/serviceaccount.yaml' $JOB_METRICS_REPORT_GENERATOR_SERVICE_NAME
jobMetricsReportGeneratorImageDigest=$(getDockerImageDigest $JOB_METRICS_REPORT_GENERATOR_SERVICE_NAME $JOB_METRICS_REPORT_GENERATOR_IMAGE_VERSION)
applyKubeFile 'jobs/metrics-report-generator/cronjob.yaml' $JOB_METRICS_REPORT_GENERATOR_SERVICE_NAME $jobMetricsReportGeneratorImageDigest $JOB_METRICS_REPORT_GENERATOR_RESOURCE_CPU $JOB_METRICS_REPORT_GENERATOR_RESOURCE_MEM

applyKubeFile 'jobs/padigitale-report-generator/configmap.yaml' $JOB_PADIGITALE_REPORT_GENERATOR_SERVICE_NAME
applyKubeFile 'jobs/padigitale-report-generator/serviceaccount.yaml' $JOB_PADIGITALE_REPORT_GENERATOR_SERVICE_NAME
jobPADigitaleReportGeneratorImageDigest=$(getDockerImageDigest $JOB_PADIGITALE_REPORT_GENERATOR_SERVICE_NAME $JOB_PADIGITALE_REPORT_GENERATOR_IMAGE_VERSION)
applyKubeFile 'jobs/padigitale-report-generator/cronjob.yaml' $JOB_PADIGITALE_REPORT_GENERATOR_SERVICE_NAME $jobPADigitaleReportGeneratorImageDigest $JOB_PADIGITALE_REPORT_GENERATOR_RESOURCE_CPU $JOB_PADIGITALE_REPORT_GENERATOR_RESOURCE_MEM

applyKubeFile 'jobs/eservices-monitoring-exporter/configmap.yaml' $JOB_ESERVICES_MONITORING_EXPORTER_SERVICE_NAME
applyKubeFile 'jobs/eservices-monitoring-exporter/serviceaccount.yaml' $JOB_ESERVICES_MONITORING_EXPORTER_SERVICE_NAME
jobEservicesMonitoringExporterImageDigest=$(getDockerImageDigest $JOB_ESERVICES_MONITORING_EXPORTER_SERVICE_NAME $JOB_ESERVICES_MONITORING_EXPORTER_IMAGE_VERSION)
applyKubeFile 'jobs/eservices-monitoring-exporter/cronjob.yaml' $JOB_ESERVICES_MONITORING_EXPORTER_SERVICE_NAME $jobEservicesMonitoringExporterImageDigest $JOB_ESERVICES_MONITORING_EXPORTER_RESOURCE_CPU $JOB_ESERVICES_MONITORING_EXPORTER_RESOURCE_MEM

applyKubeFile 'jobs/dtd-catalog-exporter/configmap.yaml' $JOB_DTD_CATALOG_EXPORTER_SERVICE_NAME
applyKubeFile 'jobs/dtd-catalog-exporter/serviceaccount.yaml' $JOB_DTD_CATALOG_EXPORTER_SERVICE_NAME
jobDTDCatalogExporterImageDigest=$(getDockerImageDigest $JOB_DTD_CATALOG_EXPORTER_SERVICE_NAME $JOB_DTD_CATALOG_EXPORTER_IMAGE_VERSION)
applyKubeFile 'jobs/dtd-catalog-exporter/cronjob.yaml' $JOB_DTD_CATALOG_EXPORTER_SERVICE_NAME $jobDTDCatalogExporterImageDigest $JOB_DTD_CATALOG_EXPORTER_RESOURCE_CPU $JOB_DTD_CATALOG_EXPORTER_RESOURCE_MEM

applyKubeFile 'jobs/one-trust-notices/configmap.yaml' $JOB_ONE_TRUST_NOTICES_SERVICE_NAME
applyKubeFile 'jobs/one-trust-notices/serviceaccount.yaml' $JOB_ONE_TRUST_NOTICES_SERVICE_NAME
jobOneTrustNoticeImageDigest=$(getDockerImageDigest $JOB_ONE_TRUST_NOTICES_SERVICE_NAME $JOB_ONE_TRUST_NOTICES_IMAGE_VERSION)
applyKubeFile 'jobs/one-trust-notices/cronjob.yaml' $JOB_ONE_TRUST_NOTICES_SERVICE_NAME $jobOneTrustNoticeImageDigest $JOB_ONE_TRUST_NOTICES_RESOURCE_CPU $JOB_ONE_TRUST_NOTICES_RESOURCE_MEM

applyKubeFile 'thirdparty/redis/deployment.yaml' $REDIS_SERVICE_NAME "" $REDIS_RESOURCE_CPU $REDIS_RESOURCE_MEM
applyKubeFile 'thirdparty/redis/service.yaml' $REDIS_SERVICE_NAME

applyKubeFile 'thirdparty/smtp-mock/deployment.yaml' $SMTP_MOCK_SERVICE_NAME "" $SMTP_MOCK_RESOURCE_CPU $SMTP_MOCK_RESOURCE_MEM
applyKubeFile 'thirdparty/smtp-mock/service.yaml' $SMTP_MOCK_SERVICE_NAME

createIngress \
    $API_GATEWAY_SERVICE_NAME $API_GATEWAY_APPLICATION_PATH $BACKEND_SERVICE_PORT \
    $AUTHORIZATION_SERVER_SERVICE_NAME $AUTHORIZATION_SERVER_APPLICATION_PATH $BACKEND_SERVICE_PORT \
    $BACKEND_FOR_FRONTEND_SERVICE_NAME $BACKEND_FOR_FRONTEND_APPLICATION_PATH $BACKEND_SERVICE_PORT \
    $FRONTEND_SERVICE_NAME $FRONTEND_SERVICE_APPLICATION_PATH $FRONTEND_SERVICE_PORT
