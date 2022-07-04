pipeline {

    agent {
        kubernetes {
            label "kubectl-template"
            yaml """
apiVersion: v1
kind: Pod
spec:
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
    POSTGRES_CREDENTIALS = credentials('postgres-db')
    DOCUMENTDB_CREDENTIALS = credentials('documentdb')
    //
    VAULT_TOKEN = credentials('vault-token')
    VAULT_ADDR = credentials('vault-addr')
    USER_REGISTRY_API_KEY = credentials('user-registry-api-key')
    PARTY_PROCESS_API_KEY = credentials('party-process-api-key')
    PARTY_MANAGEMENT_API_KEY = credentials('party-management-api-key')
    ECR_CREDENTIALS = credentials('ecr-credentials')
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
              }
              steps {
                applyKubeFile('frontend/configmap.yaml', SERVICE_NAME)
                applyKubeFile('frontend/deployment.yaml', SERVICE_NAME, IMAGE_DIGEST)
                applyKubeFile('frontend/service.yaml', SERVICE_NAME)
              }
            }
            stage('Agreement Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/agreement-management', 
                  getVariableFromConf("AGREEMENT_MANAGEMENT_SERVICE_NAME"), 
                  getVariableFromConf("AGREEMENT_MANAGEMENT_IMAGE_VERSION")
                )
              }
            }
            stage('Agreement Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/agreement-process', 
                  getVariableFromConf("AGREEMENT_PROCESS_SERVICE_NAME"),
                  getVariableFromConf("AGREEMENT_PROCESS_IMAGE_VERSION")
                )
              }
            }
            stage('Attribute Registry Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/attribute-registry-management', 
                  getVariableFromConf("ATTRIBUTE_REGISTRY_MANAGEMENT_SERVICE_NAME"), 
                  getVariableFromConf("ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION")
                )
              }
            }
            stage('Authorization Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/authorization-management', 
                  getVariableFromConf("AUTHORIZATION_MANAGEMENT_SERVICE_NAME"),
                  getVariableFromConf("AUTHORIZATION_MANAGEMENT_IMAGE_VERSION")
                )
              }
            }
            stage('Authorization Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/authorization-process', 
                  getVariableFromConf("AUTHORIZATION_PROCESS_SERVICE_NAME"),
                  getVariableFromConf("AUTHORIZATION_PROCESS_IMAGE_VERSION")
                )
              }
            }
            stage('Catalog Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/catalog-management', 
                  getVariableFromConf("CATALOG_MANAGEMENT_SERVICE_NAME"),
                  getVariableFromConf("CATALOG_MANAGEMENT_IMAGE_VERSION")
                )
              }
            }
            stage('Catalog Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/catalog-process', 
                  getVariableFromConf("CATALOG_PROCESS_SERVICE_NAME"),
                  getVariableFromConf("CATALOG_PROCESS_IMAGE_VERSION")
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
                  getVariableFromConf("PARTY_MOCK_REGISTRY_IMAGE_VERSION")
                )
              }
            }
            stage('Party Registry Proxy') {
              steps {
                applyKustomizeToDir(
                  'overlays/party-registry-proxy', 
                  getVariableFromConf("PARTY_REGISTRY_PROXY_SERVICE_NAME"), 
                  getVariableFromConf("PARTY_REGISTRY_PROXY_IMAGE_VERSION")
                )
              }
            }
            stage('Purpose Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/purpose-management', 
                  getVariableFromConf("PURPOSE_MANAGEMENT_SERVICE_NAME"), 
                  getVariableFromConf("PURPOSE_MANAGEMENT_IMAGE_VERSION")
                )
              }
            }
            stage('Purpose Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/purpose-process', 
                  getVariableFromConf("PURPOSE_PROCESS_SERVICE_NAME"), 
                  getVariableFromConf("PURPOSE_PROCESS_IMAGE_VERSION")
                )
              }
            }

            stage('Backend for Frontend') {
              steps {
                applyKustomizeToDir(
                  'overlays/backend-for-frontend', 
                  getVariableFromConf("BACKEND_FOR_FRONTEND_SERVICE_NAME"),
                  getVariableFromConf("BACKEND_FOR_FRONTEND_IMAGE_VERSION")
                )
              }
            }

            stage('API Gateway') {
              steps {
                applyKustomizeToDir(
                  'overlays/api-gateway', 
                  getVariableFromConf("API_GATEWAY_SERVICE_NAME"),
                  getVariableFromConf("API_GATEWAY_IMAGE_VERSION")
                )
              }
            }

            stage('Authorization Server') {
              steps {
                applyKustomizeToDir(
                  'overlays/authorization-server', 
                  getVariableFromConf("AUTHORIZATION_SERVER_SERVICE_NAME"),
                  getVariableFromConf("AUTHORIZATION_SERVER_IMAGE_VERSION")
                )
              }
            }

            stage('Notifier') {
              steps {
                applyKustomizeToDir(
                  'overlays/notifier', 
                  getVariableFromConf("NOTIFIER_SERVICE_NAME"),
                  getVariableFromConf("NOTIFIER_IMAGE_VERSION")
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
                  }
                  steps {
                    applyKubeFile('jobs/attributes-loader/configmap.yaml', SERVICE_NAME)
                    applyKubeFile('jobs/attributes-loader/serviceaccount.yaml', SERVICE_NAME)
                    applyKubeFile('jobs/attributes-loader/cronjob.yaml', SERVICE_NAME, IMAGE_DIGEST)
                  }
                }

                stage('Token Details Persister') {
                  environment {
                    SERVICE_NAME = getVariableFromConf("JOB_DETAILS_PERSISTER_SERVICE_NAME")
                    IMAGE_VERSION = getVariableFromConf("JOB_DETAILS_PERSISTER_IMAGE_VERSION")
                    IMAGE_DIGEST =  getDockerImageDigest(SERVICE_NAME, IMAGE_VERSION)
                  }
                  steps {
                    applyKubeFile('jobs/token-details-persister/configmap.yaml', SERVICE_NAME)
                    applyKubeFile('jobs/token-details-persister/serviceaccount.yaml', SERVICE_NAME)
                    applyKubeFile('jobs/token-details-persister/cronjob.yaml', SERVICE_NAME, IMAGE_DIGEST)
                  }
                }
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

void applyKubeFile(String fileName, String serviceName = null, String imageDigest = null) {
  container('kubectl-container') {
    withKubeConfig([credentialsId: 'kube-config']) {

      echo "Apply file ${fileName} on Kubernetes"

      echo "Compiling file ${fileName}"
      sh "SERVICE_NAME=${serviceName} IMAGE_DIGEST=${imageDigest} LOWERCASE_ENV=${env.STAGE.toLowerCase()} AWS_ACCOUNT_ID=${env.AWS_ACCOUNT_ID} ./kubernetes/templater.sh ./kubernetes/${fileName} -s -f ${env.CONFIG_FILE} > ./kubernetes/" + '$(dirname ' + fileName + ')/compiled.$(basename ' + fileName + ')'
      echo "File ${fileName} compiled"
      
      // DEBUG
      sh "cat ./kubernetes/" + '$(dirname ' + fileName + ')/compiled.$(basename ' + fileName + ')'

      echo "Applying file ${fileName}"
      sh "kubectl apply -f ./kubernetes/" + '$(dirname ' + fileName + ')/compiled.$(basename ' + fileName + ')'
      echo "File ${fileName} applied"

    }
  }
}

// dirPath starting from kubernetes folder (e.g. overlays/party-management)
void applyKustomizeToDir(String dirPath, String serviceName, String imageVersion) {
  container('kubectl-container') {
    withKubeConfig([credentialsId: 'kube-config']) {

      echo "Apply directory ${dirPath} on Kubernetes"

      def serviceImageDigest = getDockerImageDigest(serviceName, imageVersion)

      def kubeDirPath = 'kubernetes/' + dirPath

      echo "Compiling base files"
      compileDir("kubernetes/base", serviceName, imageVersion, serviceImageDigest)
      echo "Base files compiled"

      echo "Compiling common files"
      compileDir("kubernetes/commons/database", serviceName, imageVersion, serviceImageDigest)
      compileDir("kubernetes/commons/read-model", serviceName, imageVersion, serviceImageDigest)
      echo "Common files compiled"

      echo "Compiling directory ${dirPath}"
      compileDir(kubeDirPath, serviceName, imageVersion, serviceImageDigest)
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
  }

  waitForServiceReady(serviceName)

}

void waitForServiceReady(String serviceName) {
  container('kubectl-container') {
    withKubeConfig([credentialsId: 'kube-config']) {

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
}

/*
 * Compile each file in the directory replacing placeholders with actual values.
 * Note: kustomization.yaml is skipped because does not have placeholders
 */ 
void compileDir(String dirPath, String serviceName, String imageVersion, String serviceImageDigest) {
  sh '''
  for f in ''' + dirPath + '''/*
  do
      if [ ! $(basename $f) = "kustomization.yaml" ]
        then
          mkdir -p ''' + serviceName + '/' + dirPath + '''
          SERVICE_NAME=''' + serviceName + ' IMAGE_VERSION=' + imageVersion + ' IMAGE_DIGEST=' + serviceImageDigest + ' LOWERCASE_ENV=' + env.STAGE.toLowerCase() + ' AWS_ACCOUNT_ID=' + env.AWS_ACCOUNT_ID + ' kubernetes/templater.sh $f -s -f ' + env.CONFIG_FILE + ' > ' + serviceName + '''/$f
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
      return 'fe-test'
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
    withKubeConfig([credentialsId: 'kube-config']) {
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
    withKubeConfig([credentialsId: 'kube-config']) {
      loadSecret('user-registry', 'USER_REGISTRY_API_KEY', 'USER_REGISTRY_API_KEY')
      loadSecret('party-process', 'PARTY_PROCESS_API_KEY', 'PARTY_PROCESS_API_KEY')
      loadSecret('party-management', 'PARTY_MANAGEMENT_API_KEY', 'PARTY_MANAGEMENT_API_KEY')
      loadSecret('postgres', 'POSTGRES_USR', 'POSTGRES_CREDENTIALS_USR', 'POSTGRES_PSW', 'POSTGRES_CREDENTIALS_PSW')
      loadSecret('documentdb', 'DOCUMENTDB_USR', 'DOCUMENTDB_CREDENTIALS_USR', 'DOCUMENTDB_PSW', 'DOCUMENTDB_CREDENTIALS_PSW')
      loadSecret('vault', 'VAULT_ADDR', 'VAULT_ADDR', 'VAULT_TOKEN', 'VAULT_TOKEN')
    }
  }
}


String getVariableFromConf(String variableName) {
  def configFile = getConfigFileFromStage(env.STAGE)
  return sh (returnStdout: true, script: 'set +x && . ' + configFile + ' && set -x && echo $' + variableName).trim()
}

void prepareDbMigrations() {
  container('kubectl-container') {
    withKubeConfig([credentialsId: 'kube-config']) {
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
