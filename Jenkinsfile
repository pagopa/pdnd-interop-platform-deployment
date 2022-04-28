pipeline {

  agent any

  environment {
    // STAGE variable should be set as Global Properties
    STAGE = "${env.STAGE}"
    // TODO Create one set of credentials for each service
    AWS_SECRET_ACCESS = credentials('aws-credentials')
    POSTGRES_CREDENTIALS = credentials('postgres-db')
    //
    VAULT_TOKEN = credentials('vault-token')
    VAULT_ADDR = credentials('vault-addr')
    SMTP_CREDENTIALS = credentials('smtp')
    USER_REGISTRY_API_KEY = credentials('user-registry-api-key')
    ONBOARDING_DESTINATION_MAILS = credentials('onboarding-destination-mails')
    DOCKER_REGISTRY_CREDENTIALS = credentials('pdnd-nexus')
    ECR_CREDENTIALS = credentials('ecr-credentials')
    NAMESPACE = normalizeNamespaceName(env.GIT_LOCAL_BRANCH)
    REPOSITORY = getVariableFromConf("REPOSITORY")
    CONFIG_FILE = getConfigFileFromStage(STAGE)
  }

  stages {
    stage('Platform') {
      // This is required only for kubectl command (we do not need sbt)
      agent { 
        label 'sbt-template' 
      }
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
        stage('Create Roles') {
          steps {
              applyKubeFile('roles.yaml')
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
                applyKubeFile('frontend/ingress.yaml', SERVICE_NAME)
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
                  getVariableFromConf("AGREEMENT_MANAGEMENT_APPLICATION_PATH"), 
                  getVariableFromConf("AGREEMENT_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("INTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("INTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('Agreement Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/agreement-process', 
                  getVariableFromConf("AGREEMENT_PROCESS_SERVICE_NAME"),
                  getVariableFromConf("AGREEMENT_PROCESS_APPLICATION_PATH"), 
                  getVariableFromConf("AGREEMENT_PROCESS_IMAGE_VERSION"),
                  getVariableFromConf("EXTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("EXTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('Attribute Registry Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/attribute-registry-management', 
                  getVariableFromConf("ATTRIBUTE_REGISTRY_MANAGEMENT_SERVICE_NAME"),
                  getVariableFromConf("ATTRIBUTE_REGISTRY_MANAGEMENT_APPLICATION_PATH"), 
                  getVariableFromConf("ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("EXTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("EXTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('Authorization Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/authorization-management', 
                  getVariableFromConf("AUTHORIZATION_MANAGEMENT_SERVICE_NAME"),
                  getVariableFromConf("AUTHORIZATION_MANAGEMENT_APPLICATION_PATH"), 
                  getVariableFromConf("AUTHORIZATION_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("INTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("INTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('Authorization Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/authorization-process', 
                  getVariableFromConf("AUTHORIZATION_PROCESS_SERVICE_NAME"),
                  getVariableFromConf("AUTHORIZATION_PROCESS_APPLICATION_PATH"), 
                  getVariableFromConf("AUTHORIZATION_PROCESS_IMAGE_VERSION"),
                  getVariableFromConf("EXTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("EXTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('Catalog Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/catalog-management', 
                  getVariableFromConf("CATALOG_MANAGEMENT_SERVICE_NAME"),
                  getVariableFromConf("CATALOG_MANAGEMENT_APPLICATION_PATH"), 
                  getVariableFromConf("CATALOG_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("INTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("INTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('Catalog Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/catalog-process', 
                  getVariableFromConf("CATALOG_PROCESS_SERVICE_NAME"),
                  getVariableFromConf("CATALOG_PROCESS_APPLICATION_PATH"), 
                  getVariableFromConf("CATALOG_PROCESS_IMAGE_VERSION"),
                  getVariableFromConf("EXTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("EXTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('Party Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/party-management', 
                  getVariableFromConf("PARTY_MANAGEMENT_SERVICE_NAME"), 
                  getVariableFromConf("PARTY_MANAGEMENT_APPLICATION_PATH"), 
                  getVariableFromConf("PARTY_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("INTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("INTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('Party Mock Registry') {
              steps {
                applyKustomizeToDir(
                  'overlays/party-mock-registry', 
                  getVariableFromConf("PARTY_MOCK_REGISTRY_SERVICE_NAME"), 
                  getVariableFromConf("PARTY_MOCK_REGISTRY_APPLICATION_PATH"), 
                  getVariableFromConf("PARTY_MOCK_REGISTRY_IMAGE_VERSION"),
                  getVariableFromConf("INTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("INTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('Party Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/party-process', 
                  getVariableFromConf("PARTY_PROCESS_SERVICE_NAME"), 
                  getVariableFromConf("PARTY_PROCESS_APPLICATION_PATH"), 
                  getVariableFromConf("PARTY_PROCESS_IMAGE_VERSION"),
                  getVariableFromConf("EXTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("EXTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('Party Registry Proxy') {
              steps {
                applyKustomizeToDir(
                  'overlays/party-registry-proxy', 
                  getVariableFromConf("PARTY_REGISTRY_PROXY_SERVICE_NAME"), 
                  getVariableFromConf("PARTY_REGISTRY_PROXY_APPLICATION_PATH"), 
                  getVariableFromConf("PARTY_REGISTRY_PROXY_IMAGE_VERSION"),
                  getVariableFromConf("INTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("INTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('Purpose Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/purpose-management', 
                  getVariableFromConf("PURPOSE_MANAGEMENT_SERVICE_NAME"), 
                  getVariableFromConf("PURPOSE_MANAGEMENT_APPLICATION_PATH"), 
                  getVariableFromConf("PURPOSE_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("INTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("INTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('Purpose Process') {
              steps {
                applyKustomizeToDir(
                  'overlays/purpose-process', 
                  getVariableFromConf("PURPOSE_PROCESS_SERVICE_NAME"), 
                  getVariableFromConf("PURPOSE_PROCESS_APPLICATION_PATH"), 
                  getVariableFromConf("PURPOSE_PROCESS_IMAGE_VERSION"),
                  getVariableFromConf("EXTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("EXTERNAL_INGRESS_CLASS")
                )
              }
            }
            stage('User Registry Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/user-registry-management', 
                  getVariableFromConf("USER_REGISTRY_MANAGEMENT_SERVICE_NAME"), 
                  getVariableFromConf("USER_REGISTRY_MANAGEMENT_APPLICATION_PATH"), 
                  getVariableFromConf("USER_REGISTRY_MANAGEMENT_IMAGE_VERSION"),
                  getVariableFromConf("INTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("INTERNAL_INGRESS_CLASS")
                )
              }
            }

            stage('Backend for Frontend') {
              steps {
                applyKustomizeToDir(
                  'overlays/backend-for-frontend', 
                  getVariableFromConf("BACKEND_FOR_FRONTEND_SERVICE_NAME"),
                  getVariableFromConf("BACKEND_FOR_FRONTEND_SERVICE_PATH"),
                  getVariableFromConf("BACKEND_FOR_FRONTEND_IMAGE_VERSION"),
                  getVariableFromConf("EXTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("EXTERNAL_INGRESS_CLASS")
                )
              }
            }

            stage('API Gateway') {
              steps {
                applyKustomizeToDir(
                  'overlays/api-gateway', 
                  getVariableFromConf("API_GATEWAY_SERVICE_NAME"),
                  getVariableFromConf("API_GATEWAY_APPLICATION_PATH"),
                  getVariableFromConf("API_GATEWAY_IMAGE_VERSION"),
                  getVariableFromConf("EXTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("EXTERNAL_INGRESS_CLASS")
                )
              }
            }

            stage('Authorization Server') {
              steps {
                applyKustomizeToDir(
                  'overlays/authorization-server', 
                  getVariableFromConf("AUTHORIZATION_SERVER_SERVICE_NAME"),
                  getVariableFromConf("AUTHORIZATION_SERVER_APPLICATION_PATH"),
                  getVariableFromConf("AUTHORIZATION_SERVER_IMAGE_VERSION"),
                  getVariableFromConf("EXTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("EXTERNAL_INGRESS_CLASS")
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
                    applyKubeFile('jobs/attributes-loader/cronjob.yaml', SERVICE_NAME, IMAGE_DIGEST)
                  }
                }
              }
            }
            
            stage('Spid') {
              when { 
                anyOf {
                  environment name: 'STAGE', value: 'DEV'
                  environment name: 'STAGE', value: 'TEST' 
                }
              }
              environment {
                SPID_LOGIN_SAML_CERT = credentials('spid-login-saml-cert')
                SPID_LOGIN_SAML_KEY = credentials('spid-login-saml-key')
                SPID_LOGIN_JWT_PRIVATE_KEY = credentials('spid-login-jwt-private-key')
              }
              
              stages {
                stage('Secrets') {
                  steps {
                    loadSpidSecrets()
                  }
                }

                stage('Redis') {
                  steps {
                    applyKubeFile('spid/redis/configmap.yaml', "redis")
                    applyKubeFile('spid/redis/deployment.yaml', "redis")
                    applyKubeFile('spid/redis/service.yaml', "redis")

                    waitForServiceReady("redis")
                  }
                }

                stage('Login') {
                  steps {
                    applyKubeFile('spid/login/ingress.yaml', "hub-spid-login-ms")
                    applyKubeFile('spid/login/configmap.yaml', "hub-spid-login-ms")
                    applyKubeFile('spid/login/deployment.yaml', "hub-spid-login-ms")
                    applyKubeFile('spid/login/service.yaml', "hub-spid-login-ms")

                    waitForServiceReady("hub-spid-login-ms")
                  }
                }

                stage('IdP') {
                  steps {
                    applyKubeFile('spid/idp/pvc.yaml', "spid-testenv2")
                    applyKubeFile('spid/idp/ingress.yaml', "spid-testenv2")
                    applyKubeFile('spid/idp/configmap.yaml', "spid-testenv2")
                    applyKubeFile('spid/idp/deployment.yaml', "spid-testenv2")
                    applyKubeFile('spid/idp/service.yaml', "spid-testenv2")

                    waitForServiceReady("spid-testenv2")
                  }
                }

                stage('IdP Proxy') {
                  steps {
                    applyKubeFile('spid/idp-reverse-proxy/ingress.yaml', "idp-reverse-proxy")
                    applyKubeFile('spid/idp-reverse-proxy/configmap.yaml', "idp-reverse-proxy")
                    applyKubeFile('spid/idp-reverse-proxy/deployment.yaml', "idp-reverse-proxy")
                    applyKubeFile('spid/idp-reverse-proxy/service.yaml', "idp-reverse-proxy")

                    waitForServiceReady("idp-reverse-proxy")
                  }
                }

              }
            }
          }
        }
      }
    }
  }
}

void applyKubeFile(String fileName, String serviceName = null, String imageDigest = null) {
  container('sbt-container') { // This is required only for kubectl command (we do not need sbt)
    withKubeConfig([credentialsId: 'kube-config']) {

      echo "Apply file ${fileName} on Kubernetes"

      echo "Compiling file ${fileName}"
      sh "SERVICE_NAME=${serviceName} IMAGE_DIGEST=${imageDigest} ./kubernetes/templater.sh ./kubernetes/${fileName} -s -f ${env.CONFIG_FILE} > ./kubernetes/" + '$(dirname ' + fileName + ')/compiled.$(basename ' + fileName + ')'
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
void applyKustomizeToDir(String dirPath, String serviceName, String applicationPath, String imageVersion, String hostname, String ingressClass) {
  container('sbt-container') { // This is required only for kubectl command (we do not need sbt)
    withKubeConfig([credentialsId: 'kube-config']) {

      echo "Apply directory ${dirPath} on Kubernetes"

      def serviceImageDigest = getDockerImageDigest(serviceName, imageVersion)

      def kubeDirPath = 'kubernetes/' + dirPath

      echo "Compiling base files"
      compileDir("kubernetes/base", serviceName, applicationPath, imageVersion, hostname, ingressClass, serviceImageDigest)
      echo "Base files compiled"

      echo "Compiling common files"
      compileDir("kubernetes/commons/database", serviceName, applicationPath, imageVersion, hostname, ingressClass, serviceImageDigest)
      echo "Common files compiled"

      echo "Compiling directory ${dirPath}"
      compileDir(kubeDirPath, serviceName, applicationPath, imageVersion, hostname, ingressClass, serviceImageDigest)
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
  container('sbt-container') { // This is required only for kubectl command (we do not need sbt)
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
void compileDir(String dirPath, String serviceName, String applicationPath, String imageVersion, String hostname, String ingressClass, String serviceImageDigest) {
  sh '''
  for f in ''' + dirPath + '''/*
  do
      if [ ! $(basename $f) = "kustomization.yaml" ]
        then
          mkdir -p ''' + serviceName + '/' + dirPath + '''
          SERVICE_NAME=''' + serviceName + ' APPLICATION_PATH=' + applicationPath + ' IMAGE_VERSION=' + imageVersion + ' IMAGE_DIGEST=' + serviceImageDigest + ' APPLICATION_HOST=' + hostname + ' INGRESS_CLASS=' + ingressClass + ' kubernetes/templater.sh $f -s -f ' + env.CONFIG_FILE + ' > ' + serviceName + '''/$f
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

String normalizeNamespaceName(String namespace) {
  return namespace
     .replace('_', '-')
     .replace('.', '-')
     .toLowerCase()
}

void loadCredentials(String secretName, String userSecret, String userVar, String passwordSecret, String passwordVar) {
  sh'''
    # Allow to update secret if already exists
    kubectl -n $NAMESPACE create secret generic ''' + secretName + ''' \
      --save-config \
      --dry-run=client \
      --from-literal=''' + userSecret + '=$' + userVar + ''' \
      --from-literal=''' + passwordSecret + '=$' + passwordVar + ''' \
      -o yaml | kubectl apply -f -
  '''
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
  container('sbt-container') { // This is required only for kubectl command (sbt is not needed)
    withKubeConfig([credentialsId: 'kube-config']) {
      sh'''
        # Cleanup
        kubectl -n $NAMESPACE delete secrets regcred --ignore-not-found
        kubectl -n default get secret regcred -o yaml | sed s/"namespace: default"/"namespace: $NAMESPACE"/ |  kubectl apply -n $NAMESPACE -f -
      '''

      loadSecret(getVariableFromConf("PARTY_PROCESS_SERVICE_NAME"), 'ONBOARDING_DESTINATION_MAILS', 'ONBOARDING_DESTINATION_MAILS')
      loadSecret('user-registry-api-key', 'USER_REGISTRY_API_KEY', 'USER_REGISTRY_API_KEY')
      loadCredentials('storage', 'STORAGE_USR', 'AWS_SECRET_ACCESS_USR', 'STORAGE_PSW', 'AWS_SECRET_ACCESS_PSW')
      loadCredentials('aws', 'AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_USR', 'AWS_SECRET_ACCESS_KEY', 'AWS_SECRET_ACCESS_PSW')
      loadCredentials('postgres', 'POSTGRES_USR', 'POSTGRES_CREDENTIALS_USR', 'POSTGRES_PSW', 'POSTGRES_CREDENTIALS_PSW')
      loadCredentials('vault', 'VAULT_ADDR', 'VAULT_ADDR', 'VAULT_TOKEN', 'VAULT_TOKEN')
      loadCredentials('smtp', 'SMTP_USR', 'SMTP_CREDENTIALS_USR', 'SMTP_PSW', 'SMTP_CREDENTIALS_PSW')
    }
  }
}


void loadSpidSecrets() {
  container('sbt-container') { // This is required only for kubectl command (sbt is not needed)
    withKubeConfig([credentialsId: 'kube-config']) {
      
      sh'''
        kubectl -n $NAMESPACE create secret generic spid-login \
          --save-config \
          --dry-run=client \
          --from-file=METADATA_PUBLIC_CERT="$SPID_LOGIN_SAML_CERT" \
          --from-file=METADATA_PRIVATE_CERT="$SPID_LOGIN_SAML_KEY" \
          --from-file=JWT_TOKEN_PRIVATE_KEY="$SPID_LOGIN_JWT_PRIVATE_KEY" \
          -o yaml | kubectl apply -f -

        kubectl -n $NAMESPACE create secret generic idp-http-certs \
          --save-config \
          --dry-run=client \
          --from-file=cert.pem=$SPID_LOGIN_SAML_CERT \
          --from-file=key.pem=$SPID_LOGIN_SAML_KEY \
          -o yaml | kubectl apply -f -

      '''
    }
  }
}

String getVariableFromConf(String variableName) {
  def configFile = getConfigFileFromStage(env.STAGE)
  return sh (returnStdout: true, script: 'set +x && . ' + configFile + ' && set -x && echo $' + variableName).trim()
}

void prepareDbMigrations() {
  container('sbt-container') { // This is required only for kubectl command (sbt is not needed)
    withKubeConfig([credentialsId: 'kube-config']) {
      echo 'Creating migrations configmap...'
      sh'''kubectl \
         create configmap common-db-migrations \
         --namespace $NAMESPACE \
         --from-file=db/migrations/ \
         --dry-run \
         -o yaml | kubectl apply -f -'''
      echo 'Migrations configmap created'
    }
  }
}


String getDockerImageDigest(String serviceName, String imageVersion) {
  echo "Retrieving digest for service ${serviceName} and version ${imageVersion}..."
    container('sbt-container') { // This is required only for docker command (sbt is not needed)

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
