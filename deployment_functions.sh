function getSecretValue() {
  secretId=$1

  secretValue="$(aws secretsmanager get-secret-value \
    --secret-id "$secretId" \
    | jq -r '.SecretString')"

  echo "$secretValue"
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

function createReadModelUser() {
  user=$1
  password=$2
  role=$3

  adminUser="$(getSecretValue 'documentdb-admin-username')"
  adminPassword="$(getSecretValue 'documentdb-admin-password')"

  encodedAdminUser=$(urlEncode "$adminUser")
  encodedAdminPassword=$(urlEncode "$adminPassword")
  encodedNewUser=$(urlEncode "$user")
  encodedNewPassword=$(urlEncode "$password")

  mongosh mongodb://${encodedAdminUser}:${encodedAdminPassword}@$READ_MODEL_DB_HOST:$READ_MODEL_DB_PORT/admin \
          --eval "if(db.getUser(\"${encodedNewUser}\") == null) { db.createUser({
            user: \"${encodedNewUser}\",
            pwd: \"${encodedNewPassword}\",
            roles: [ {role: \"${role}\", db: "$READ_MODEL_DB_NAME"} ]
          })}"
}


function createKubeSecret() {
  secretName=$1
  compiledFileName="./kubernetes/compiled.secret.$secretName.yaml"

  shift
  tuples=("${@}")
  length=${#tuples[@]}

  header="kubectl -n $NAMESPACE create secret generic ${secretName} --save-config --dry-run=client"
  command=$header

  for (( j=0; j<length; j=j+2 )); do
    i=$j
    k=$((j+1))
    secretKey="${tuples[$i]}"
    secretValue="${tuples[$k]}"
    echo -n "$secretValue" > "${secretKey}.txt"
    command="$command --from-file=${secretKey}=./${secretKey}.txt"
  done

  echo "Compiling $secretName secret manifest"
  eval "$command -o yaml > $compiledFileName"

  echo "Applying $compiledFileName"
  kubectl apply -f $compiledFileName
  echo "Applied: $compiledFileName"
}

function prepareDbMigrations() {
  echo "Creating DB migrations configmap"

  kubectl \
    create configmap common-db-migrations \
    --namespace $NAMESPACE \
    --from-file=db/migrations/ \
    --dry-run=client \
    -o yaml | kubectl apply -f -

  echo "DB migrations configmap created"
}

function getDockerImageDigest() {
  serviceName=$1
  imageVersion=$2

  imageSHA56="$(aws ecr batch-get-image --repository-name "${serviceName}" --image-ids "imageTag=$imageVersion" \
              | jq -r '.images[0].imageId.imageDigest')"

  echo "$imageSHA56"
}

function applyKubeFile() {
  fileName=$1
  serviceName=$2
  imageDigest=$3
  resourceCpu=$4
  resourceMem=$5

  compiledFileName="./kubernetes/$(dirname $fileName)/compiled.$(basename $fileName)"

  echo "Compiling file $fileName"

  SERVICE_NAME=$serviceName \
    IMAGE_DIGEST=$imageDigest \
    SERVICE_RESOURCE_CPU=$resourceCpu \
    SERVICE_RESOURCE_MEM=$resourceMem \
    LOWERCASE_ENV=$(echo "$ENVIRONMENT" | tr '[:upper:]' '[:lower:]') \
    ./kubernetes/templater.sh "./kubernetes/$fileName" \
      -s -f $CONFIG_FILE \
      > "$compiledFileName"

  echo "File $fileName compiled"
  cat $compiledFileName

  echo "Applying $compiledFileName"
  kubectl apply -f "$compiledFileName"
  echo "File $compiledFileName applied"
}

function compileDir() {
  dirPath=$1
  serviceName=$2
  imageVersion=$3
  imageDigest=$4
  resourceCpu=$5
  resourceMem=$6


  for f in $dirPath/*; do
    if [ ! $(basename $f) = "kustomization.yaml" ]; then
      mkdir -p "${serviceName}/${dirPath}"
      SERVICE_NAME="$serviceName" \
        IMAGE_VERSION="$imageVersion" \
        IMAGE_DIGEST="$imageDigest" \
        SERVICE_RESOURCE_CPU="$resourceCpu" \
        SERVICE_RESOURCE_MEM="$resourceMem" \
        LOWERCASE_ENV=$(echo "$ENVIRONMENT" | tr '[:upper:]' '[:lower:]') \
        ./kubernetes/templater.sh "$f" -s -f $CONFIG_FILE \
        > "$serviceName/$f"
    else
      cp $f "$serviceName/$f"
    fi
  done
}

function applyKustomizeToDir() {
  # dirPath starting from kubernetes folder (e.g. overlays/party-management)
  dirPath=$1
  serviceName=$2
  imageVersion=$3
  resourceCpu=$4
  resourceMem=$5

  echo "Retrieving image digest for ${serviceName} version ${imageVersion}"
  serviceImageDigest="$(getDockerImageDigest $serviceName $imageVersion)"
  echo "Image digest: $serviceImageDigest"

  kubeDirPath="kubernetes/${dirPath}"

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
  kubectl kustomize --load-restrictor LoadRestrictionsNone "${serviceName}/${kubeDirPath}" \
    > "${serviceName}/full.${serviceName}.yaml"
  echo "Kustomization for ${serviceName} applied"

  cat "${serviceName}/full.${serviceName}.yaml"

  echo "Applying files for ${serviceName}"
  kubectl apply -f "${serviceName}/full.${serviceName}.yaml"
  echo "Files for ${serviceName} applied"
}

function waitForServiceReady() {
  serviceName=$1

  retry=0
  result=0
  maxRetries=10
  echo "Waiting for pod creation for ${serviceName}"
  while [ "$result" -lt 1 -a "$retry" -lt "$maxRetries" ]; do
    sleep 3
    result=$(kubectl --namespace="$NAMESPACE" get pod -l app="$serviceName"  2>/dev/null \
      | grep "$serviceName" | wc -l)
    retry=$((retry+1))
  done

  echo "Waiting for pod readiness for ${serviceName}"
  kubectl wait --for condition=Ready pod -l app="${serviceName}" --namespace="$NAMESPACE" --timeout=120s
}
