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

    eval $(source ./${LOWERCASE_ENV}-secrets; echo awsAccountId=$AWS_ACCOUNT_ID)

    for f in $dirPath/*
    do
        if [ ! $(basename $f) = "kustomization.yaml" ]
        then
            mkdir -p $serviceName/$dirPath
            SERVICE_NAME=$serviceName IMAGE_VERSION=$imageVersion IMAGE_DIGEST=$serviceImageDigest AWS_ACCOUNT_ID=$awsAccountId kubernetes/templater.sh $f -s -f $CONFIG_FILE > $serviceName/$f
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

    echo "********** ${serviceName} **********"
    echo "Apply directory ${dirPath} on Kubernetes"

    serviceImageDigest=$(getDockerImageDigest $serviceName $imageVersion)

    kubeDirPath='kubernetes/'$dirPath

    echo "Compiling base files"
    compileDir "kubernetes/base" $serviceName $imageVersion $serviceImageDigest
    echo "Base files compiled"

    echo "Compiling common files"
    compileDir "kubernetes/commons/database" $serviceName $imageVersion $serviceImageDigest
    echo "Common files compiled"

    echo "Compiling directory ${dirPath}"
    compileDir $kubeDirPath $serviceName $imageVersion $serviceImageDigest
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

    echo "Apply file ${fileName} on Kubernetes"

    eval $(source ./${LOWERCASE_ENV}-secrets; echo awsAccountId=$AWS_ACCOUNT_ID)

    echo "Compiling file ${fileName}"
    SERVICE_NAME=${serviceName} IMAGE_DIGEST=${imageDigest} AWS_ACCOUNT_ID=$awsAccountId ./kubernetes/templater.sh ./kubernetes/${fileName} -s -f ${CONFIG_FILE} > ./kubernetes/$(dirname $fileName)/compiled.$(basename $fileName)
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
    loadSecret 'postgres' 'POSTGRES_USR' 'POSTGRES_CREDENTIALS_USR' 'POSTGRES_PSW' 'POSTGRES_CREDENTIALS_PSW'
    loadSecret 'vault' 'VAULT_ADDR' 'VAULT_ADDR' 'VAULT_TOKEN' 'VAULT_TOKEN'

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

if [ ${LOWERCASE_ENV} != 'prod' ]; then 
  applyKustomizeToDir 'overlays/party-mock-registry' $PARTY_MOCK_REGISTRY_SERVICE_NAME $PARTY_MOCK_REGISTRY_IMAGE_VERSION
fi

applyKubeFile 'frontend/configmap.yaml' $FRONTEND_SERVICE_NAME
frontendImageDigest=$(getDockerImageDigest $FRONTEND_SERVICE_NAME $FRONTEND_IMAGE_VERSION)
applyKubeFile 'frontend/deployment.yaml' $FRONTEND_SERVICE_NAME $frontendImageDigest
applyKubeFile 'frontend/service.yaml' $FRONTEND_SERVICE_NAME

applyKustomizeToDir 'overlays/agreement-management' $AGREEMENT_MANAGEMENT_SERVICE_NAME $AGREEMENT_MANAGEMENT_IMAGE_VERSION
applyKustomizeToDir 'overlays/agreement-process' $AGREEMENT_PROCESS_SERVICE_NAME $AGREEMENT_PROCESS_IMAGE_VERSION
applyKustomizeToDir 'overlays/attribute-registry-management' $ATTRIBUTE_REGISTRY_MANAGEMENT_SERVICE_NAME $ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION
applyKustomizeToDir 'overlays/authorization-management' $AUTHORIZATION_MANAGEMENT_SERVICE_NAME $AUTHORIZATION_MANAGEMENT_IMAGE_VERSION
applyKustomizeToDir 'overlays/authorization-process' $AUTHORIZATION_PROCESS_SERVICE_NAME $AUTHORIZATION_PROCESS_IMAGE_VERSION
applyKustomizeToDir 'overlays/authorization-server' $AUTHORIZATION_SERVER_SERVICE_NAME $AUTHORIZATION_SERVER_IMAGE_VERSION
applyKustomizeToDir 'overlays/catalog-management' $CATALOG_MANAGEMENT_SERVICE_NAME $CATALOG_MANAGEMENT_IMAGE_VERSION
applyKustomizeToDir 'overlays/catalog-process' $CATALOG_PROCESS_SERVICE_NAME $CATALOG_PROCESS_IMAGE_VERSION
applyKustomizeToDir 'overlays/party-registry-proxy' $PARTY_REGISTRY_PROXY_SERVICE_NAME $PARTY_REGISTRY_PROXY_IMAGE_VERSION
applyKustomizeToDir 'overlays/purpose-management' $PURPOSE_MANAGEMENT_SERVICE_NAME $PURPOSE_MANAGEMENT_IMAGE_VERSION
applyKustomizeToDir 'overlays/purpose-process' $PURPOSE_PROCESS_SERVICE_NAME $PURPOSE_PROCESS_IMAGE_VERSION
applyKustomizeToDir 'overlays/backend-for-frontend' $BACKEND_FOR_FRONTEND_SERVICE_NAME $BACKEND_FOR_FRONTEND_IMAGE_VERSION
applyKustomizeToDir 'overlays/api-gateway' $API_GATEWAY_SERVICE_NAME $API_GATEWAY_IMAGE_VERSION
applyKustomizeToDir 'overlays/notifier' $NOTIFIER_SERVICE_NAME $NOTIFIER_IMAGE_VERSION

applyKubeFile 'jobs/attributes-loader/configmap.yaml' $JOB_ATTRIBUTES_LOADER_SERVICE_NAME
applyKubeFile 'jobs/attributes-loader/serviceaccount.yaml' $JOB_ATTRIBUTES_LOADER_SERVICE_NAME
attributesLoaderImageDigest=$(getDockerImageDigest $JOB_ATTRIBUTES_LOADER_SERVICE_NAME $JOB_ATTRIBUTES_LOADER_IMAGE_VERSION)
applyKubeFile 'jobs/attributes-loader/cronjob.yaml' $JOB_ATTRIBUTES_LOADER_SERVICE_NAME $attributesLoaderImageDigest

applyKubeFile 'jobs/token-details-persister/configmap.yaml' $JOB_DETAILS_PERSISTER_SERVICE_NAME
applyKubeFile 'jobs/token-details-persister/serviceaccount.yaml' $JOB_DETAILS_PERSISTER_SERVICE_NAME
jobDetailsPersisterImageDigest=$(getDockerImageDigest $JOB_DETAILS_PERSISTER_SERVICE_NAME $JOB_DETAILS_PERSISTER_IMAGE_VERSION)
applyKubeFile 'jobs/token-details-persister/cronjob.yaml' $JOB_DETAILS_PERSISTER_SERVICE_NAME $jobDetailsPersisterImageDigest

createIngress \
    $AGREEMENT_PROCESS_SERVICE_NAME $AGREEMENT_PROCESS_APPLICATION_PATH $BACKEND_SERVICE_PORT \
    $API_GATEWAY_SERVICE_NAME $API_GATEWAY_APPLICATION_PATH $BACKEND_SERVICE_PORT \
    $AUTHORIZATION_PROCESS_SERVICE_NAME $AUTHORIZATION_PROCESS_APPLICATION_PATH $BACKEND_SERVICE_PORT \
    $AUTHORIZATION_SERVER_SERVICE_NAME $AUTHORIZATION_SERVER_APPLICATION_PATH $BACKEND_SERVICE_PORT \
    $BACKEND_FOR_FRONTEND_SERVICE_NAME $BACKEND_FOR_FRONTEND_APPLICATION_PATH $BACKEND_SERVICE_PORT \
    $CATALOG_PROCESS_SERVICE_NAME $CATALOG_PROCESS_APPLICATION_PATH $BACKEND_SERVICE_PORT \
    $FRONTEND_SERVICE_NAME $FRONTEND_SERVICE_APPLICATION_PATH $FRONTEND_SERVICE_PORT \
    $PURPOSE_PROCESS_SERVICE_NAME $PURPOSE_PROCESS_APPLICATION_PATH $BACKEND_SERVICE_PORT
