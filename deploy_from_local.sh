
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "Usage $0 namespace"
    exit 1
fi

export NAMESPACE=$1

export CONFIG_FILE='./kubernetes/configs/test/main.sh'

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

    for f in $dirPath/*
    do
        if [ ! $(basename $f) = "kustomization.yaml" ]
        then
            mkdir -p $serviceName/$dirPath
            SERVICE_NAME=$serviceName IMAGE_VERSION=$imageVersion IMAGE_DIGEST=$serviceImageDigest kubernetes/templater.sh $f -s -f $CONFIG_FILE > $serviceName/$f
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

    echo "Apply directory ${dirPath} on Kubernetes"

    # def serviceImageDigest = getDockerImageDigest(serviceName, imageVersion)
    serviceImageDigest="blabla"

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

    # DEBUG
    # cat ${serviceName}/full.${serviceName}.yaml

    # echo "Applying files for ${serviceName}"
    # kubectl apply -f ${serviceName}/full.${serviceName}.yaml
    # echo "Files for ${serviceName} applied"

    echo "Removing folder"
    rm -rf ${serviceName}
    echo "Folder removed"
}


function applyKubeFile() {
    fileName=$1
    serviceName=$2
    imageDigest=$3

    echo "Apply file ${fileName} on Kubernetes"

    echo "Compiling file ${fileName}"
    SERVICE_NAME=${serviceName} IMAGE_DIGEST=${imageDigest} ./kubernetes/templater.sh ./kubernetes/${fileName} -s -f ${CONFIG_FILE} > ./kubernetes/$(dirname $fileName)/compiled.$(basename $fileName)
    echo "File ${fileName} compiled"
    
    # DEBUG
    # sh "cat ./kubernetes/" + '$(dirname ' + fileName + ')/compiled.$(basename ' + fileName + ')'

    echo "Applying file ${fileName}"
    # kubectl apply -f ./kubernetes/$(dirname $fileName)/compiled.$(basename $fileName)
    echo "File ${fileName} applied"

    echo "Removing file"
    rm -rf ./kubernetes/$(dirname $fileName)/compiled.$(basename $fileName)
    echo "File removed"
}


function prepareDbMigrations() {
    echo 'Creating migrations configmap...'
    kubectl \
        create configmap common-db-migrations \
        --namespace $NAMESPACE \
        --from-file=db/migrations/ \
        --dry-run \
        -o yaml | kubectl apply -f -
    echo 'Migrations configmap created'
}


function loadSecret() {
    secretName=$1

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

    command="$command -o yaml | kubectl apply -f -"

    eval $command
}

function loadSecrets() {
    source ./secrets
    loadSecret 'storage' 'STORAGE_USR' 'AWS_SECRET_ACCESS_USR' 'STORAGE_PSW' 'AWS_SECRET_ACCESS_PSW'
    loadSecret 'aws' 'AWS_ACCESS_KEY_ID' 'AWS_SECRET_ACCESS_USR' 'AWS_SECRET_ACCESS_KEY' 'AWS_SECRET_ACCESS_PSW' 'AWS_ACCOUNT_ID' 'AWS_ACCOUNT_ID'
    loadSecret 'postgres' 'POSTGRES_USR' 'POSTGRES_CREDENTIALS_USR' 'POSTGRES_PSW' 'POSTGRES_CREDENTIALS_PSW'
    loadSecret 'vault' 'VAULT_ADDR' 'VAULT_ADDR' 'VAULT_TOKEN' 'VAULT_TOKEN'
}

function createIngress() {

    tuples=("${@}")
    length=${#tuples[@]}

    baseCommand="kubectl -n $NAMESPACE create ingress interop-services --class=alb --dry-run=client -o yaml "
    annotations='--annotation="alb.ingress.kubernetes.io/scheme=internet-facing" --annotation="alb.ingress.kubernetes.io/target-type=ip" '

    rules = ''

    for (( j=0; j<length; j=j+2 ));
    do
    i=$j
    k=$((j+1))
    command="$command--from-literal=${tuples[$i]}=\${${tuples[$k]}} "
    rules=$rules' --rule="/'${tuples[$i]}'*='${tuples[$k]}':8088" '
    done

    eval("$baseCommand $annotations $rules | kubectl apply -f -"
}



applyKubeFile 'namespace.yaml'
applyKubeFile 'roles.yaml'
# loadSecrets()
# prepareDbMigrations()

applyKubeFile 'frontend/configmap.yaml', $FRONTEND_SERVICE_NAME
applyKubeFile 'frontend/deployment.yaml', $FRONTEND_SERVICE_NAME "IMAGE_DIGEST_TBD"
applyKubeFile 'frontend/service.yaml', $FRONTEND_SERVICE_NAME

applyKustomizeToDir 'overlays/agreement-management' $AGREEMENT_MANAGEMENT_SERVICE_NAME $AGREEMENT_MANAGEMENT_IMAGE_VERSION
applyKustomizeToDir 'overlays/agreement-process' $AGREEMENT_PROCESS_SERVICE_NAME $AGREEMENT_PROCESS_IMAGE_VERSION
applyKustomizeToDir 'overlays/attribute-registry-management' $ATTRIBUTE_REGISTRY_MANAGEMENT_APPLICATION_PATH $ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION
applyKustomizeToDir 'overlays/authorization-management' $AUTHORIZATION_MANAGEMENT_SERVICE_NAME $AUTHORIZATION_MANAGEMENT_IMAGE_VERSION
applyKustomizeToDir 'overlays/authorization-process' $AUTHORIZATION_PROCESS_SERVICE_NAME $AUTHORIZATION_PROCESS_IMAGE_VERSION
applyKustomizeToDir 'overlays/catalog-management' $CATALOG_MANAGEMENT_SERVICE_NAME $CATALOG_MANAGEMENT_IMAGE_VERSION
applyKustomizeToDir 'overlays/catalog-process' $CATALOG_PROCESS_SERVICE_NAME $CATALOG_PROCESS_IMAGE_VERSION
applyKustomizeToDir 'overlays/party-registry-proxy' $PARTY_REGISTRY_PROXY_SERVICE_NAME $PARTY_REGISTRY_PROXY_IMAGE_VERSION
applyKustomizeToDir 'overlays/purpose-management' $PURPOSE_MANAGEMENT_SERVICE_NAME $PURPOSE_MANAGEMENT_IMAGE_VERSION
applyKustomizeToDir 'overlays/purpose-process' $PURPOSE_PROCESS_SERVICE_NAME $PURPOSE_PROCESS_IMAGE_VERSION
applyKustomizeToDir 'overlays/backend-for-frontend' $BACKEND_FOR_FRONTEND_SERVICE_NAME $BACKEND_FOR_FRONTEND_IMAGE_VERSION
applyKustomizeToDir 'overlays/api-gateway' $API_GATEWAY_SERVICE_NAME $API_GATEWAY_IMAGE_VERSION
applyKustomizeToDir 'overlays/notifier' $NOTIFIER_SERVICE_NAME $NOTIFIER_IMAGE_VERSION

applyKubeFile 'jobs/attributes-loader/configmap.yaml' $JOB_ATTRIBUTES_LOADER_SERVICE_NAME
applyKubeFile 'jobs/attributes-loader/cronjob.yaml' $JOB_ATTRIBUTES_LOADER_SERVICE_NAME "IMAGE_DIGEST_TBD"

createIngress \
    $AGREEMENT_MANAGEMENT_SERVICE_NAME $AGREEMENT_MANAGEMENT_APPLICATION_PATH \
    $AGREEMENT_PROCESS_SERVICE_NAME $AGREEMENT_PROCESS_APPLICATION_PATH \
    $API_GATEWAY_SERVICE_NAME $API_GATEWAY_APPLICATION_PATH \
    $ATTRIBUTE_REGISTRY_MANAGEMENT_SERVICE_NAME $ATTRIBUTE_REGISTRY_MANAGEMENT_APPLICATION_PATH \
    $AUTHORIZATION_MANAGEMENT_SERVICE_NAME $AUTHORIZATION_MANAGEMENT_APPLICATION_PATH \
    $AUTHORIZATION_PROCESS_SERVICE_NAME $AUTHORIZATION_PROCESS_APPLICATION_PATH \
    $AUTHORIZATION_SERVER_SERVICE_NAME $AUTHORIZATION_SERVER_APPLICATION_PATH \
    $BACKEND_FOR_FRONTEND_SERVICE_NAME $BACKEND_FOR_FRONTEND_APPLICATION_PATH \
    $CATALOG_MANAGEMENT_SERVICE_NAME $CATALOG_MANAGEMENT_APPLICATION_PATH \
    $CATALOG_PROCESS_SERVICE_NAME $CATALOG_PROCESS_APPLICATION_PATH \
    $FRONTEND_SERVICE_NAME $FRONTEND_SERVICE_APPLICATION_PAT \
    $NOTIFIER_SERVICE_NAME $NOTIFIER_APPLICATION_PATH \
    $PURPOSE_MANAGEMENT_SERVICE_NAME $PURPOSE_MANAGEMENT_APPLICATION_PATH \
    $PURPOSE_PROCESS_SERVICE_NAME $PURPOSE_PROCESS_APPLICATION_PATH
