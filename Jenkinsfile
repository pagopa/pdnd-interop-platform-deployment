pipeline {

    agent {
        kubernetes {
            label "kubectl-template"
            yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
    - name: kubectl-container
      image: lachlanevenson/k8s-kubectl:v1.23.6
      resources:
        requests:
          cpu: 1
          memory: 1Gi
        limits:
          cpu: 1
          memory: 1Gi
      command:
        - /bin/ash
      args: [ "-c", "apk add bash docker aws-cli && cat"]
      tty: true
"""
        }
    }

  environment {
    // STAGE variable should be set as Global Properties
    STAGE = "${env.STAGE}"
    AWS_ACCOUNT_ID = credentials('aws-account-id')
    // TODO Create one set of credentials for each service
    POSTGRES_CREDENTIALS_USR = credentials('postgres-db-username')
    POSTGRES_CREDENTIALS_PSW = credentials('postgres-db-password')
    READ_MODEL_CREDENTIALS_ADMIN_USR = credentials('documentdb-admin-username')
    READ_MODEL_CREDENTIALS_ADMIN_PSW = credentials('documentdb-admin-password')
    READ_MODEL_CREDENTIALS_PROJECTION_USR = credentials('documentdb-projection-username')
    READ_MODEL_CREDENTIALS_PROJECTION_PSW = credentials('documentdb-projection-password')
    READ_MODEL_CREDENTIALS_RO_USR = credentials('documentdb-ro-username')
    READ_MODEL_CREDENTIALS_RO_PSW = credentials('documentdb-ro-password')
    //
    VAULT_TOKEN = credentials('vault-token')
    VAULT_ADDR = credentials('vault-addr')
    USER_REGISTRY_API_KEY = credentials('user-registry-api-key')
    PARTY_PROCESS_API_KEY = credentials('party-process-api-key')
    PARTY_MANAGEMENT_API_KEY = credentials('party-management-api-key')
    ECR_CREDENTIALS_USR = credentials('ecr-credentials-username')
    ECR_CREDENTIALS_PSW = credentials('ecr-credentials-password')
    NAMESPACE = normalizeNamespaceName(env.GIT_LOCAL_BRANCH, "${env.STAGE}")
    REPOSITORY = getVariableFromConf("REPOSITORY")
    CONFIG_FILE = getConfigFileFromStage(STAGE)
  }

  stages {
    stage('Platform') {
      stages {

        stage('Debug') {
          // DELETE ME. Just for testing
          steps {
            sh'env'
          }
        }
        
        stage('Prepare MongoDB') {

          agent {
              kubernetes {
                  label "mongodb-migrations-template"
                  yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
    - name: mongodb-migrations
      image: mongo:6.0.2-focal
      resources:
        requests:
          cpu: 1
          memory: 1Gi
        limits:
          cpu: 1
          memory: 1Gi
      command:
        - /bin/sh
      args: [ "-c", "cat"]
      tty: true
"""
              }
          }
          environment {
            READ_MODEL_DB_HOST = getVariableFromConf("READ_MODEL_DB_HOST")
            READ_MODEL_DB_PORT = getVariableFromConf("READ_MODEL_DB_PORT")
            READ_MODEL_DB_NAME = getVariableFromConf("READ_MODEL_DB_NAME")
          }
          steps {
            createReadModelUser(READ_MODEL_CREDENTIALS_RO_USR, READ_MODEL_CREDENTIALS_RO_PSW, "read")
            createReadModelUser(READ_MODEL_CREDENTIALS_PROJECTION_USR, READ_MODEL_CREDENTIALS_PROJECTION_PSW, "readWrite")
          }
        }

        stage('Create Namespace') {
          steps {
              applyKubeFile('namespace.yaml')
          }
        }
        stage('Load Secrets') {
          steps {
              loadSecrets()
          }
        }
        stage('Load ConfigMaps') {
          steps {
              prepareDbMigrations()
          }
        }
        stage('Deploy Services') {
          parallel {
            stage('Front End') {
              environment {
                SERVICE_NAME = getVariableFromConf("FRONTEND_SERVICE_NAME")
                IMAGE_VERSION = getVariableFromConf("FRONTEND_IMAGE_VERSION")
                IMAGE_DIGEST =  getDockerImageDigest(SERVICE_NAME, IMAGE_VERSION)
                RESOURCE_CPU = getVariableFromConf("FRONTEND_RESOURCE_CPU")
                RESOURCE_MEM = getVariableFromConf("FRONTEND_RESOURCE_MEM")
              }
              steps {
                applyKubeFile('frontend/configmap.yaml', SERVICE_NAME)
                applyKubeFile('frontend/deployment.yaml', SERVICE_NAME, IMAGE_DIGEST, RESOURCE_CPU, RESOURCE_MEM)
                applyKubeFile('frontend/service.yaml', SERVICE_NAME)
              }
            }
            stage('Agreement Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/agreement-management', 
                  getVariableFromConf("AGREEMENT_MANAGEMENT_SERVICE_NAME"), 
                  getVariableFromConf("AGREEMENT_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("AGREEMENT_MANAGEMENT_RESOURCE_CPU"),
                  getVariableFromConf("AGREEMENT_MANAGEMENT_RESOURCE_MEM")
                )
              }
            }
            stage('Agreement Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/agreement-process', 
                  getVariableFromConf("AGREEMENT_PROCESS_SERVICE_NAME"),
                  getVariableFromConf("AGREEMENT_PROCESS_IMAGE_VERSION"),
                  getVariableFromConf("AGREEMENT_PROCESS_RESOURCE_CPU"),
                  getVariableFromConf("AGREEMENT_PROCESS_RESOURCE_MEM")
                )
              }
            }
            stage('Attribute Registry Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/attribute-registry-management', 
                  getVariableFromConf("ATTRIBUTE_REGISTRY_MANAGEMENT_SERVICE_NAME"), 
                  getVariableFromConf("ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("ATTRIBUTE_REGISTRY_MANAGEMENT_RESOURCE_CPU"),
                  getVariableFromConf("ATTRIBUTE_REGISTRY_MANAGEMENT_RESOURCE_MEM")
                )
              }
            }
            stage('Authorization Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/authorization-management', 
                  getVariableFromConf("AUTHORIZATION_MANAGEMENT_SERVICE_NAME"),
                  getVariableFromConf("AUTHORIZATION_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("AUTHORIZATION_MANAGEMENT_RESOURCE_CPU"),
                  getVariableFromConf("AUTHORIZATION_MANAGEMENT_RESOURCE_MEM")
                )
              }
            }
            stage('Authorization Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/authorization-process', 
                  getVariableFromConf("AUTHORIZATION_PROCESS_SERVICE_NAME"),
                  getVariableFromConf("AUTHORIZATION_PROCESS_IMAGE_VERSION"),
                  getVariableFromConf("AUTHORIZATION_PROCESS_RESOURCE_CPU"),
                  getVariableFromConf("AUTHORIZATION_PROCESS_RESOURCE_MEM")
                )
              }
            }
            stage('Catalog Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/catalog-management', 
                  getVariableFromConf("CATALOG_MANAGEMENT_SERVICE_NAME"),
                  getVariableFromConf("CATALOG_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("CATALOG_MANAGEMENT_RESOURCE_CPU"),
                  getVariableFromConf("CATALOG_MANAGEMENT_RESOURCE_MEM")
                )
              }
            }
            stage('Catalog Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/catalog-process', 
                  getVariableFromConf("CATALOG_PROCESS_SERVICE_NAME"),
                  getVariableFromConf("CATALOG_PROCESS_IMAGE_VERSION"),
                  getVariableFromConf("CATALOG_PROCESS_RESOURCE_CPU"),
                  getVariableFromConf("CATALOG_PROCESS_RESOURCE_MEM")
                )
              }
            }
            stage('Party Mock Registry') {
              when { 
                anyOf {
                  environment name: 'STAGE', value: 'DEV'
                  environment name: 'STAGE', value: 'TEST' 
                }
              }
              steps {
                applyKustomizeToDir(
                  'overlays/party-mock-registry', 
                  getVariableFromConf("PARTY_MOCK_REGISTRY_SERVICE_NAME"), 
                  getVariableFromConf("PARTY_MOCK_REGISTRY_IMAGE_VERSION"),
                  getVariableFromConf("PARTY_MOCK_REGISTRY_RESOURCE_CPU"),
                  getVariableFromConf("PARTY_MOCK_REGISTRY_RESOURCE_MEM")
                )
              }
            }
            stage('Party Registry Proxy') {
              steps {
                applyKustomizeToDir(
                  'overlays/party-registry-proxy', 
                  getVariableFromConf("PARTY_REGISTRY_PROXY_SERVICE_NAME"), 
                  getVariableFromConf("PARTY_REGISTRY_PROXY_IMAGE_VERSION"),
                  getVariableFromConf("PARTY_REGISTRY_PROXY_RESOURCE_CPU"),
                  getVariableFromConf("PARTY_REGISTRY_PROXY_RESOURCE_MEM")
                )
              }
            }
            stage('Purpose Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/purpose-management', 
                  getVariableFromConf("PURPOSE_MANAGEMENT_SERVICE_NAME"), 
                  getVariableFromConf("PURPOSE_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("PURPOSE_MANAGEMENT_RESOURCE_CPU"),
                  getVariableFromConf("PURPOSE_MANAGEMENT_RESOURCE_MEM")
                )
              }
            }
            stage('Purpose Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/purpose-process', 
                  getVariableFromConf("PURPOSE_PROCESS_SERVICE_NAME"), 
                  getVariableFromConf("PURPOSE_PROCESS_IMAGE_VERSION"),
                  getVariableFromConf("PURPOSE_PROCESS_RESOURCE_CPU"),
                  getVariableFromConf("PURPOSE_PROCESS_RESOURCE_MEM")
                )
              }
            }

            stage('Tenant Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/tenant-management', 
                  getVariableFromConf("TENANT_MANAGEMENT_SERVICE_NAME"), 
                  getVariableFromConf("TENANT_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("TENANT_MANAGEMENT_RESOURCE_CPU"),
                  getVariableFromConf("TENANT_MANAGEMENT_RESOURCE_MEM")
                )
              }
            }
            stage('Tenant Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/tenant-process', 
                  getVariableFromConf("TENANT_PROCESS_SERVICE_NAME"), 
                  getVariableFromConf("TENANT_PROCESS_IMAGE_VERSION"),
                  getVariableFromConf("TENANT_PROCESS_RESOURCE_CPU"),
                  getVariableFromConf("TENANT_PROCESS_RESOURCE_MEM")
                )
              }
            }

            stage('Backend for Frontend') {
              steps {
                applyKustomizeToDir(
                  'overlays/backend-for-frontend', 
                  getVariableFromConf("BACKEND_FOR_FRONTEND_SERVICE_NAME"),
                  getVariableFromConf("BACKEND_FOR_FRONTEND_IMAGE_VERSION"),
                  getVariableFromConf("BACKEND_FOR_FRONTEND_RESOURCE_CPU"),
                  getVariableFromConf("BACKEND_FOR_FRONTEND_RESOURCE_MEM")
                )
              }
            }

            stage('API Gateway') {
              steps {
                applyKustomizeToDir(
                  'overlays/api-gateway', 
                  getVariableFromConf("API_GATEWAY_SERVICE_NAME"),
                  getVariableFromConf("API_GATEWAY_IMAGE_VERSION"),
                  getVariableFromConf("API_GATEWAY_RESOURCE_CPU"),
                  getVariableFromConf("API_GATEWAY_RESOURCE_MEM")
                )
              }
            }

            stage('Authorization Server') {
              steps {
                applyKustomizeToDir(
                  'overlays/authorization-server', 
                  getVariableFromConf("AUTHORIZATION_SERVER_SERVICE_NAME"),
                  getVariableFromConf("AUTHORIZATION_SERVER_IMAGE_VERSION"),
                  getVariableFromConf("AUTHORIZATION_SERVER_RESOURCE_CPU"),
                  getVariableFromConf("AUTHORIZATION_SERVER_RESOURCE_MEM")
                )
              }
            }

            stage('Notifier') {
              steps {
                applyKustomizeToDir(
                  'overlays/notifier', 
                  getVariableFromConf("NOTIFIER_SERVICE_NAME"),
                  getVariableFromConf("NOTIFIER_IMAGE_VERSION"),
                  getVariableFromConf("NOTIFIER_RESOURCE_CPU"),
                  getVariableFromConf("NOTIFIER_RESOURCE_MEM")
                )
              }
            }

            stage('Jobs') {
              stages {
                stage('Attributes Loader') {
                  environment {
                    SERVICE_NAME = getVariableFromConf("JOB_ATTRIBUTES_LOADER_SERVICE_NAME")
                    IMAGE_VERSION = getVariableFromConf("JOB_ATTRIBUTES_LOADER_IMAGE_VERSION")
                    IMAGE_DIGEST =  getDockerImageDigest(SERVICE_NAME, IMAGE_VERSION)
                    RESOURCE_CPU = getVariableFromConf("JOB_ATTRIBUTES_LOADER_RESOURCE_CPU")
                    RESOURCE_MEM = getVariableFromConf("JOB_ATTRIBUTES_LOADER_RESOURCE_MEM")
                  }
                  steps {
                    applyKubeFile('jobs/attributes-loader/configmap.yaml', SERVICE_NAME)
                    applyKubeFile('jobs/attributes-loader/serviceaccount.yaml', SERVICE_NAME)
                    applyKubeFile('jobs/attributes-loader/cronjob.yaml', SERVICE_NAME, IMAGE_DIGEST, RESOURCE_CPU, RESOURCE_MEM)
                  }
                }

                stage('Token Details Persister') {
                  environment {
                    SERVICE_NAME = getVariableFromConf("JOB_DETAILS_PERSISTER_SERVICE_NAME")
                    IMAGE_VERSION = getVariableFromConf("JOB_DETAILS_PERSISTER_IMAGE_VERSION")
                    IMAGE_DIGEST =  getDockerImageDigest(SERVICE_NAME, IMAGE_VERSION)
                    RESOURCE_CPU = getVariableFromConf("JOB_DETAILS_PERSISTER_RESOURCE_CPU")
                    RESOURCE_MEM = getVariableFromConf("JOB_DETAILS_PERSISTER_RESOURCE_MEM")
                  }
                  steps {
                    applyKubeFile('jobs/token-details-persister/configmap.yaml', SERVICE_NAME)
                    applyKubeFile('jobs/token-details-persister/serviceaccount.yaml', SERVICE_NAME)
                    applyKubeFile('jobs/token-details-persister/cronjob.yaml', SERVICE_NAME, IMAGE_DIGEST, RESOURCE_CPU, RESOURCE_MEM)
                  }
                }

                stage('Tenants Certified Attributes Updater') {
                  environment {
                    SERVICE_NAME = getVariableFromConf("JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_SERVICE_NAME")
                    IMAGE_VERSION = getVariableFromConf("JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_IMAGE_VERSION")
                    IMAGE_DIGEST =  getDockerImageDigest(SERVICE_NAME, IMAGE_VERSION)
                    RESOURCE_CPU = getVariableFromConf("JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_RESOURCE_CPU")
                    RESOURCE_MEM = getVariableFromConf("JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_RESOURCE_MEM")
                  }
                  steps {
                    applyKubeFile('jobs/tenants-certified-attributes-updater/configmap.yaml', SERVICE_NAME)
                    applyKubeFile('jobs/tenants-certified-attributes-updater/serviceaccount.yaml', SERVICE_NAME)
                    applyKubeFile('jobs/tenants-certified-attributes-updater/cronjob.yaml', SERVICE_NAME, IMAGE_DIGEST, RESOURCE_CPU, RESOURCE_MEM)
                  }
                }

              }
            }

            stage('Redis') {
              environment {
                SERVICE_NAME = getVariableFromConf("REDIS_SERVICE_NAME")
                RESOURCE_CPU = getVariableFromConf("REDIS_RESOURCE_CPU")
                RESOURCE_MEM = getVariableFromConf("REDIS_RESOURCE_MEM")
              }
              steps {
                applyKubeFile('thirdparty/redis/deployment.yaml', SERVICE_NAME, "", RESOURCE_CPU, RESOURCE_MEM)
                applyKubeFile('thirdparty/redis/service.yaml', SERVICE_NAME)

                waitForServiceReady(SERVICE_NAME)
              }
            }

          }
        }
        stage('Create Ingress') {
          steps {
            createIngress(
              getVariableFromConf("AGREEMENT_PROCESS_SERVICE_NAME"), getVariableFromConf("AGREEMENT_PROCESS_APPLICATION_PATH"), getVariableFromConf("BACKEND_SERVICE_PORT"),
              getVariableFromConf("API_GATEWAY_SERVICE_NAME"), getVariableFromConf("API_GATEWAY_APPLICATION_PATH"), getVariableFromConf("BACKEND_SERVICE_PORT"),
              getVariableFromConf("AUTHORIZATION_PROCESS_SERVICE_NAME"), getVariableFromConf("AUTHORIZATION_PROCESS_APPLICATION_PATH"), getVariableFromConf("BACKEND_SERVICE_PORT"),
              getVariableFromConf("AUTHORIZATION_SERVER_SERVICE_NAME"), getVariableFromConf("AUTHORIZATION_SERVER_APPLICATION_PATH"), getVariableFromConf("BACKEND_SERVICE_PORT"),
              getVariableFromConf("BACKEND_FOR_FRONTEND_SERVICE_NAME"), getVariableFromConf("BACKEND_FOR_FRONTEND_APPLICATION_PATH"), getVariableFromConf("BACKEND_SERVICE_PORT"),
              getVariableFromConf("CATALOG_PROCESS_SERVICE_NAME"), getVariableFromConf("CATALOG_PROCESS_APPLICATION_PATH"), getVariableFromConf("BACKEND_SERVICE_PORT"),
              getVariableFromConf("FRONTEND_SERVICE_NAME"), getVariableFromConf("FRONTEND_SERVICE_APPLICATION_PATH"), getVariableFromConf("FRONTEND_SERVICE_PORT"),
              getVariableFromConf("PURPOSE_PROCESS_SERVICE_NAME"), getVariableFromConf("PURPOSE_PROCESS_APPLICATION_PATH"), getVariableFromConf("BACKEND_SERVICE_PORT"),
            )
          }
        }

      }
    }
  }
}

void applyKubeFile(String fileName, String serviceName = null, String imageDigest = null, String resourceCpu = null, String resourceMem = null) {
  container('kubectl-container') {
    echo "Apply file ${fileName} on Kubernetes"

    echo "Compiling file ${fileName}"
    sh """SERVICE_NAME=${serviceName} \
      IMAGE_DIGEST=${imageDigest} \
      SERVICE_RESOURCE_CPU=${resourceCpu} \
      SERVICE_RESOURCE_MEM=${resourceMem} \
      LOWERCASE_ENV=${env.STAGE.toLowerCase()} \
      AWS_ACCOUNT_ID=${env.AWS_ACCOUNT_ID} \
      ./kubernetes/templater.sh ./kubernetes/${fileName} \
      -s \
      -f ${env.CONFIG_FILE} > ./kubernetes/""" + '$(dirname ' + fileName + ')/compiled.$(basename ' + fileName + ')'
    echo "File ${fileName} compiled"
    
    // DEBUG
    sh "cat ./kubernetes/" + '$(dirname ' + fileName + ')/compiled.$(basename ' + fileName + ')'

    echo "Applying file ${fileName}"
    sh "kubectl apply -f ./kubernetes/" + '$(dirname ' + fileName + ')/compiled.$(basename ' + fileName + ')'
    echo "File ${fileName} applied"
  }
}

// dirPath starting from kubernetes folder (e.g. overlays/party-management)
void applyKustomizeToDir(String dirPath, String serviceName, String imageVersion, String resourceCpu, String resourceMem) {
  container('kubectl-container') {
    echo "Apply directory ${dirPath} on Kubernetes"

    def serviceImageDigest = getDockerImageDigest(serviceName, imageVersion)

    def kubeDirPath = 'kubernetes/' + dirPath

    echo "Compiling base files"
    compileDir("kubernetes/base", serviceName, imageVersion, serviceImageDigest, resourceCpu, resourceMem)
    echo "Base files compiled"

    echo "Compiling common files"
    compileDir("kubernetes/commons/database", serviceName, imageVersion, serviceImageDigest, resourceCpu, resourceMem)
    compileDir("kubernetes/commons/rate-limiting", serviceName, imageVersion, serviceImageDigest, resourceCpu, resourceMem)
    echo "Common files compiled"

    echo "Compiling directory ${dirPath}"
    compileDir(kubeDirPath, serviceName, imageVersion, serviceImageDigest, resourceCpu, resourceMem)
    echo "Directory ${dirPath} compiled"
    
    echo "Applying Kustomization for ${serviceName}"
    sh 'kubectl kustomize --load-restrictor LoadRestrictionsNone ' + serviceName + '/' + kubeDirPath + ' > ' + serviceName + '/full.' + serviceName + '.yaml'
    echo "Kustomization for ${serviceName} applied"

    // DEBUG
    sh "cat ${serviceName}/full.${serviceName}.yaml"

    echo "Applying files for ${serviceName}"
    sh "kubectl apply -f ${serviceName}/full.${serviceName}.yaml"
    echo "Files for ${serviceName} applied"

    echo "Removing folder"
    sh "rm -rf ${serviceName}"
    echo "Folder removed"
  }

  waitForServiceReady(serviceName)

}

void waitForServiceReady(String serviceName) {
  container('kubectl-container') {
    echo "Waiting for completion of ${serviceName}..."
    // TODO Pod waiting
    // Not ideal, but the wait command fails if the resource has not been created yet
    // See https://github.com/kubernetes/kubernetes/issues/83242

    // Wait for pod creation
    sh'''
      retry=0
      result=0
      maxRetries=10
      while [ "$result" -lt 1 -a "$retry" -lt "$maxRetries" ] ; do
        echo "Waiting for pod creation of service ${serviceName}..."
        sleep 3
        result=$(kubectl --namespace=\$NAMESPACE get pod -l app=''' + serviceName + ' 2>/dev/null  | grep ' + serviceName + ''' | wc -l)
        retry=$((retry+1))
      done
    '''

    // Wait for pod readiness
    sh "kubectl wait --for condition=Ready pod -l app=${serviceName} --namespace=\$NAMESPACE --timeout=120s"

    echo "Apply of ${serviceName} completed"
  }
}

/*
 * Compile each file in the directory replacing placeholders with actual values.
 * Note: kustomization.yaml is skipped because does not have placeholders
 */ 
void compileDir(String dirPath, String serviceName, String imageVersion, String serviceImageDigest, String resourceCpu, String resourceMem) {
  sh '''
  for f in ''' + dirPath + '''/*
  do
      if [ ! $(basename $f) = "kustomization.yaml" ]
        then
          mkdir -p ''' + serviceName + '/' + dirPath + '''
          SERVICE_NAME=''' + serviceName + 
            ' IMAGE_VERSION=' + imageVersion + 
            ' IMAGE_DIGEST=' + serviceImageDigest + 
            ' SERVICE_RESOURCE_CPU=' + resourceCpu + 
            ' SERVICE_RESOURCE_MEM=' + resourceMem + 
            ' LOWERCASE_ENV=' + env.STAGE.toLowerCase() + 
            ' AWS_ACCOUNT_ID=' + env.AWS_ACCOUNT_ID + 
            ' kubernetes/templater.sh $f -s -f ' + env.CONFIG_FILE + ' > ' + serviceName + '''/$f
        else
          cp $f ''' + serviceName + '''/$f
      fi
  done
  '''
}

String getConfigFileFromStage(String stage) {
  switch(stage) { 
   case 'DEV': 
     return './kubernetes/configs/dev/main.sh'
   case 'TEST': 
     return './kubernetes/configs/test/main.sh'
   case 'PROD': 
     return './kubernetes/configs/prod/main.sh'
   default:
     error "Stage not valid: ${stage}"
  } 
}

String normalizeNamespaceName(String namespace, String stage) {
  switch (stage) {
    case 'DEV':
      return 'dev'
    case 'TEST':
      return 'test'
    case 'PROD':
      return 'prod'
    default:
      return namespace
        .replace('_', '-')
        .replace('.', '-')
        .toLowerCase()
  }
}

// Params are triplets of (serviceName, applicationPath, servicePort)
void createIngress(String... variablesMappings) {
  container('kubectl-container') {
    varSize = variablesMappings.size()
    assert(varSize % 3 == 0)
    baseCommand = 'kubectl -n $NAMESPACE create ingress interop-services --class=alb --dry-run=client -o yaml '
    annotations = '--annotation="alb.ingress.kubernetes.io/scheme=internal" --annotation="alb.ingress.kubernetes.io/target-type=ip" '

    rules = ''
    for (i = 0; i < varSize; i += 3) {
        rules = rules + '--rule="/' + variablesMappings[i+1] + '*=' + variablesMappings[i] + ':' + variablesMappings[i+2] + '" '
    }

    sh(baseCommand + annotations + rules + ' | kubectl apply -f -')
  }
}

void loadSecret(String secretName, String... variablesMappings) {
    varSize = variablesMappings.size()
    assert(varSize % 2 == 0)
    header = 'kubectl -n $NAMESPACE create secret generic ' + secretName + ' --save-config --dry-run=client '
    command = header
    for (i = 0; i < varSize; i += 2) {
        command = command + '--from-literal=' + variablesMappings[i] + '=$' + variablesMappings[i+1] + ' '
    }
    command = command + '-o yaml | kubectl apply -f -'
    sh(command)
}

void loadSecrets() {
  container('kubectl-container') {
    loadSecret('user-registry', 'USER_REGISTRY_API_KEY', 'USER_REGISTRY_API_KEY')
    loadSecret('party-process', 'PARTY_PROCESS_API_KEY', 'PARTY_PROCESS_API_KEY')
    loadSecret('party-management', 'PARTY_MANAGEMENT_API_KEY', 'PARTY_MANAGEMENT_API_KEY')
    loadSecret('postgres', 'POSTGRES_USR', 'POSTGRES_CREDENTIALS_USR', 'POSTGRES_PSW', 'POSTGRES_CREDENTIALS_PSW')
    loadSecret('documentdb', 'PROJECTION_USR', 'READ_MODEL_CREDENTIALS_PROJECTION_USR', 'PROJECTION_PSW', 'READ_MODEL_CREDENTIALS_PROJECTION_PSW', 'READONLY_USR', 'READ_MODEL_CREDENTIALS_RO_USR', 'READONLY_PSW', 'READ_MODEL_CREDENTIALS_RO_PSW')
    loadSecret('vault', 'VAULT_ADDR', 'VAULT_ADDR', 'VAULT_TOKEN', 'VAULT_TOKEN')
  }
}


String getVariableFromConf(String variableName) {
  def configFile = getConfigFileFromStage(env.STAGE)
  return sh (returnStdout: true, script: 'set +x && . ' + configFile + ' && set -x && echo $' + variableName).trim()
}

void prepareDbMigrations() {
  container('kubectl-container') {
    echo 'Creating migrations configmap...'
    sh'''kubectl \
        create configmap common-db-migrations \
        --namespace $NAMESPACE \
        --from-file=db/migrations/ \
        --dry-run=client \
        -o yaml | kubectl apply -f -'''
    echo 'Migrations configmap created'
  }
}


String getDockerImageDigest(String serviceName, String imageVersion) {
  echo "Retrieving digest for service ${serviceName} and version ${imageVersion}..."
    container('kubectl-container') {

      def response = sh(
          returnStdout: true, 
          script: '''
          export AWS_ACCESS_KEY_ID=$ECR_CREDENTIALS_USR
          export AWS_SECRET_ACCESS_KEY=$ECR_CREDENTIALS_PSW
          aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin $REPOSITORY 2>/dev/null 1>&2
          docker manifest inspect $REPOSITORY/''' + serviceName + ':' + imageVersion
        ).trim()

      def jsonResponse = readJSON text: response

      def sha256 = jsonResponse.config.digest

      echo "Digest retrieved for service ${serviceName} and version ${imageVersion}: " + sha256

      return sha256
    }
  
}

void createReadModelUser(String user, String password, String role) {
  container('mongodb-migrations') {
    echo "Creating user in read model..."
    def encodedAdminUser = urlEncode(env.READ_MODEL_CREDENTIALS_ADMIN_USR)
    def encodedAdminPassword = urlEncode(env.READ_MODEL_CREDENTIALS_ADMIN_PSW)
    def encodedNewUser = urlEncode(user)
    def encodedNewPassword = urlEncode(password)

    sh"""set +x && mongosh 'mongodb://${encodedAdminUser}:${encodedAdminPassword}@$READ_MODEL_DB_HOST:$READ_MODEL_DB_PORT/admin' \
        --eval 'if(db.getUser("${encodedNewUser}") == null) { db.createUser({
          user: "${encodedNewUser}",
          pwd: "${encodedNewPassword}",
          roles: [ {role: "${role}", db: "$READ_MODEL_DB_NAME"} ]
        })}'; set -x
    """
    echo "User created in read model"
  }
}

String urlEncode(String str) {
  sh(
    returnStdout: true, 
    script: "echo '${str}'" + ''' | sed \
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
        -e 's/\\$/%24/g' \
        -e 's/\\&/%26/g' \
        -e 's/\\*/%2a/g' \
        -e 's/\\./%2e/g' \
        -e 's/\\//%2f/g' \
        -e 's/\\[/%5b/g' \
        -e 's/\\\\/%5c/g' \
        -e 's/\\]/%5d/g' \
        -e 's/\\^/%5e/g' \
        -e 's/_/%5f/g' \
        -e 's/`/%60/g' \
        -e 's/{/%7b/g' \
        -e 's/|/%7c/g' \
        -e 's/}/%7d/g' \
        -e 's/~/%7e/g'
  '''
  ).trim()
}