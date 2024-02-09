function getSecretValue() {
  local secretId=$1

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
  local user=$1
  local password=$2
  local role=$3

  adminUser="$(getSecretValue 'documentdb-admin-username')"
  adminPassword="$(getSecretValue 'documentdb-admin-password')"

  encodedAdminUser=$(urlEncode "$adminUser")
  encodedAdminPassword=$(urlEncode "$adminPassword")
  encodedNewUser=$(urlEncode "$user")
  encodedNewPassword=$(urlEncode "$password")

  mongosh mongodb://"${encodedAdminUser}":"${encodedAdminPassword}"@"$READ_MODEL_DB_HOST":"$READ_MODEL_DB_PORT"/admin \
          --eval "if(db.getUser(\"${encodedNewUser}\") == null) { db.createUser({
            user: \"${encodedNewUser}\",
            pwd: \"${encodedNewPassword}\",
            roles: [ {role: \"${role}\", db: \"$READ_MODEL_DB_NAME\"} ]
          })}"
}


function createKubeSecret() {
  local secretName=$1
  local compiledFileName="./kubernetes/compiled.secret.$secretName.yaml"

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
  kubectl apply -f "$compiledFileName"
  echo "Applied: $compiledFileName"
}

function prepareDbMigrations() {
  echo "Creating DB migrations configmap"

  kubectl \
    create configmap common-db-migrations \
    --namespace "$NAMESPACE" \
    --from-file=db/migrations/ \
    --dry-run=client \
    -o yaml | kubectl apply -f -

  echo "DB migrations configmap created"
}

function prepareEventStoreMigrations() {
  echo "Creating Event Store migrations configmap"

  kubectl \
    create configmap event-store-migrations \
    --namespace "$NAMESPACE" \
    --from-file=db/event-store/migrations/ \
    --dry-run=client \
    -o yaml | kubectl apply -f -

  echo "Event Store migrations configmap created"
}

function getDockerImageDigest() {
  local serviceName=$1
  local imageVersion=$2
  local registryId="$(echo "$REPOSITORY" | cut -d '.' -f1)"

  imageSHA56="$(aws ecr batch-get-image --registry-id "$registryId" --repository-name "$serviceName" --image-ids "imageTag=$imageVersion" \
              | jq -r '.images[0].imageId.imageDigest')"

  echo "$imageSHA56"
}

function applyKubeFile() {
  local fileName=$1
  local serviceName=$2
  local imageDigest=$3
  local resourceCpu=$4
  local resourceMem=$5

  local compiledFileName
  compiledFileName="./kubernetes/$(dirname "$fileName")/compiled.$(basename "$fileName")"

  echo "Compiling file $fileName"

  SERVICE_NAME="$serviceName" \
    SERVICE_ECR_NAME="$(echo "$serviceName" | sed 's/-refactor//')" \
    IMAGE_DIGEST="$imageDigest" \
    SERVICE_RESOURCE_CPU="$resourceCpu" \
    SERVICE_RESOURCE_MEM="$resourceMem" \
    LOWERCASE_ENV=$(echo "$ENVIRONMENT" | tr '[:upper:]' '[:lower:]' | sed 's/-refactor//') \
    ./kubernetes/templater.sh "./kubernetes/$fileName" \
      -s -f "$CONFIG_FILE" \
      > "$compiledFileName"

  echo "File $fileName compiled"
  cat "$compiledFileName"

  echo "Applying $compiledFileName"
  kubectl apply -f "$compiledFileName"
  echo "File $compiledFileName applied"
}

function compileDir() {
  local dirPath=$1
  local serviceName=$2
  local imageVersion=$3
  local imageDigest=$4
  local resourceCpu=$5
  local resourceMem=$6


  for f in "$dirPath"/*; do
    if [ -d "$f" ]; then continue; fi;

    if [ ! "$(basename "$f")" = "kustomization.yaml" ]; then
    mkdir -p "${serviceName}/${dirPath}"
    SERVICE_NAME="$serviceName" \
      SERVICE_ECR_NAME="$(echo "$serviceName" | sed 's/-refactor//')" \
      IMAGE_VERSION="$imageVersion" \
      IMAGE_DIGEST="$imageDigest" \
      SERVICE_RESOURCE_CPU="$resourceCpu" \
      SERVICE_RESOURCE_MEM="$resourceMem" \
      LOWERCASE_ENV=$(echo "$ENVIRONMENT" | tr '[:upper:]' '[:lower:]' | sed 's/-refactor//') \
      ./kubernetes/templater.sh "$f" -s -f "$CONFIG_FILE" \
      > "$serviceName/$f"
    else
      cp "$f" "$serviceName/$f"
    fi
  done
}

function applyKustomizeToDir() {
  # dirPath starting from kubernetes folder (e.g. overlays/party-management)
  local dirPath=$1
  local serviceName=$2
  local imageVersion=$3
  local resourceCpu=$4
  local resourceMem=$5

  echo "Retrieving image digest for ${serviceName} version ${imageVersion}"
  serviceEcrName="$(echo "$serviceName" | sed 's/-refactor//')"
  serviceImageDigest="$(getDockerImageDigest "$serviceEcrName" "$imageVersion")"
  echo "Image digest: $serviceImageDigest"

  kubeDirPath="kubernetes/${dirPath}"

  echo "Compiling base files"
  compileDir "kubernetes/base" "$serviceName" "$imageVersion" "$serviceImageDigest" "$resourceCpu" "$resourceMem"
  compileDir "kubernetes/base/be-refactor" "$serviceName" "$imageVersion" "$serviceImageDigest" "$resourceCpu" "$resourceMem"
  echo "Base files compiled"

  echo "Compiling common files"
  compileDir "kubernetes/commons/database" "$serviceName" "$imageVersion" "$serviceImageDigest" "$resourceCpu" "$resourceMem"
  compileDir "kubernetes/commons/rate-limiting" "$serviceName" "$imageVersion" "$serviceImageDigest" "$resourceCpu" "$resourceMem"
  echo "Common files compiled"

  echo "Compiling directory ${dirPath}"
  compileDir "$kubeDirPath" "$serviceName" "$imageVersion" "$serviceImageDigest" "$resourceCpu" "$resourceMem"
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
  local serviceName=$1

  retry=0
  result=0
  maxRetries=10
  echo "Waiting for pod creation for ${serviceName}"
  while [ "$result" -lt 1 ] && [ "$retry" -lt "$maxRetries" ]; do
    sleep 3
    result=$(kubectl --namespace="$NAMESPACE" get pod -l app="$serviceName"  2>/dev/null \
      | grep "$serviceName" | wc -l)
    retry=$((retry+1))
  done

  echo "Waiting for pod readiness for ${serviceName}"
  kubectl wait --for condition=Ready pod -l app="${serviceName}" --namespace="$NAMESPACE" --timeout=300s
}

function createIngress() {
  # Params are triplets of (serviceName, applicationPath, servicePort)
  local tuples=("${@}")
  local length=${#tuples[@]}

  local compiledFileName='./kubernetes/compiled.ingress.yaml'

  local baseCommand="kubectl -n $NAMESPACE create ingress interop-services --class=alb --dry-run=client -o yaml "
  local annotations='--annotation="alb.ingress.kubernetes.io/scheme=internal" --annotation="alb.ingress.kubernetes.io/target-type=ip" --annotation="alb.ingress.kubernetes.io/group.name=interop-be"'

  local rules=''

  for (( j=0; j<length; j=j+3 )); do
    local i=$j
    local k=$((j+1))
    local z=$((j+2))
    local serviceName="${tuples[$i]}"
    local applicationPath="${tuples[$k]}"
    local servicePort="${tuples[$z]}"

    newRule=' --rule="/'${applicationPath}'*='${serviceName}':'${servicePort}'" '
    echo "Adding rule: $newRule"
    rules=$rules''$newRule
  done

  eval "$baseCommand $annotations $rules > $compiledFileName"

  echo "Applying $compiledFileName"
  kubectl apply -f "$compiledFileName"
  echo "Applied $compiledFileName"
}
