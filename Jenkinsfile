pipeline {

  agent any

  environment {
    // STAGE variable should be set as Global Properties
    STAGE = "${env.STAGE}"
    // TODO Create one set of credentials for each service
    AWS_SECRET_ACCESS = credentials('aws-credentials')
    POSTGRES_CREDENTIALS = credentials('postgres-db')
    //
    NAMESPACE = normalizeNamespaceName(env.GIT_LOCAL_BRANCH)
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
              steps {
                  applyKubeFile('frontend/ingress.yaml', "frontend")
                  applyKubeFile('frontend/configmap.yaml', "frontend")
                  applyKubeFile('frontend/deployment.yaml', "frontend")
                  applyKubeFile('frontend/service.yaml', "frontend")
              }
            }
            stage('User Registry Management') {
              steps {
                  applyKustomizeToDir(
                    'overlays/user-registry-management', 
                    getVariableFromConf("USER_REGISTRY_MANAGEMENT_SERVICE_NAME"), 
                    getVariableFromConf("INTERNAL_APPLICATION_HOST"),
                    getVariableFromConf("INTERNAL_INGRESS_CLASS")
                  )
              }
            }
            stage('Party Management') {
              steps {
                applyKustomizeToDir(
                  'overlays/party-management', 
                  getVariableFromConf("PARTY_MANAGEMENT_SERVICE_NAME"), 
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
                  getVariableFromConf("EXTERNAL_APPLICATION_HOST"),
                  getVariableFromConf("EXTERNAL_INGRESS_CLASS")
                )
              }
            }
            
            stage('Spid') {
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
                  }
                }

                stage('Login') {
                  steps {
                    applyKubeFile('spid/login/ingress.yaml', "hub-spid-login-ms")
                    applyKubeFile('spid/login/configmap.yaml', "hub-spid-login-ms")
                    applyKubeFile('spid/login/deployment.yaml', "hub-spid-login-ms")
                    applyKubeFile('spid/login/service.yaml', "hub-spid-login-ms")
                  }
                }

                stage('IdP') {
                  steps {
                    applyKubeFile('spid/idp/ingress.yaml', "spid-testenv2")
                    applyKubeFile('spid/idp/configmap.yaml', "spid-testenv2")
                    applyKubeFile('spid/idp/deployment.yaml', "spid-testenv2")
                    applyKubeFile('spid/idp/service.yaml', "spid-testenv2")
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

void applyKubeFile(String fileName, String serviceName = null) {
  container('sbt-container') { // This is required only for kubectl command (we do not need sbt)
    withKubeConfig([credentialsId: 'kube-config']) {

      echo "Apply file ${fileName} on Kubernetes"

      echo "Compiling file ${fileName}"
      sh "SERVICE_NAME=" + serviceName + " ./kubernetes/templater.sh ./kubernetes/${fileName} -s -f ${env.CONFIG_FILE} > ./kubernetes/" + '$(dirname ' + fileName + ')/compiled.$(basename ' + fileName + ')'
      echo "File ${fileName} compiled"
      
      // DEBUG
      sh "cat ./kubernetes/" + '$(dirname ' + fileName + ')/compiled.$(basename ' + fileName + ')'

      echo "Applying file ${fileName}"
      sh "kubectl apply -f ./kubernetes/" + '$(dirname ' + fileName + ')/compiled.$(basename ' + fileName + ')'
      echo "File ${fileName} applied"

    }
  }
}

// dirPath starting from kubernetes folder (e.g. kubernetes/overlays/party-management)
void applyKustomizeToDir(String dirPath, String serviceName, String hostname, String ingressClass) {
  container('sbt-container') { // This is required only for kubectl command (we do not need sbt)
    withKubeConfig([credentialsId: 'kube-config']) {

      echo "Apply directory ${dirPath} on Kubernetes"

      def kubeDirPath = 'kubernetes/' + dirPath

      echo "Compiling base files"
      compileDir("kubernetes/base", serviceName, hostname, ingressClass)
      echo "Base files compiled"

      echo "Compiling common files"
      compileDir("kubernetes/commons/database", serviceName, hostname, ingressClass)
      echo "Common files compiled"

      echo "Compiling directory ${dirPath}"
      compileDir(kubeDirPath, serviceName, hostname, ingressClass)
      echo "Directory ${dirPath} compiled"
      
      echo "Applying Kustomization for ${serviceName}"
      sh 'kubectl kustomize --load-restrictor LoadRestrictionsNone ' + serviceName + '/' + kubeDirPath + ' > ' + serviceName + '/full.' + serviceName + '.yaml'
      echo "Kustomization for ${serviceName} applied"

      // DEBUG
      sh "cat ${serviceName}/full.${serviceName}.yaml"

      echo "Applying files for ${serviceName}"
      sh "kubectl apply -f ${serviceName}/full.${serviceName}.yaml"
      echo "Files for ${serviceName} applied"

      waitForServiceReady(serviceName)

      echo "Removing folder"
      sh "rm -rf ${serviceName}"
      echo "Folder removed"
    }
  }
}

void waitForServiceReady(String serviceName) {

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
  sh "kubectl wait --for condition=Ready pod -l app=${serviceName} --namespace=\$NAMESPACE --timeout=60s"

  echo "Apply of ${serviceName} completed"

}

/*
 * Compile each file in the directory replacing placeholders with actual values.
 * Note: kustomization.yaml is skipped because does not have placeholders
 */ 
void compileDir(String dirPath, String serviceName, String hostname, String ingressClass) {
  sh '''
  for f in ''' + dirPath + '''/*
  do
      if [ ! $(basename $f) = "kustomization.yaml" ]
        then
          mkdir -p ''' + serviceName + '/' + dirPath + '''
          SERVICE_NAME=''' + serviceName + ' APPLICATION_HOST=' + hostname + ' INGRESS_CLASS=' + ingressClass + ' kubernetes/templater.sh $f -s -f ' + env.CONFIG_FILE + ' > ' + serviceName + '''/$f
        else
          cp $f ''' + serviceName + '''/$f
      fi
  done
  '''
}

String getConfigFileFromStage(String stage) {
  switch(stage) { 
   case 'DEV': 
     return './kubernetes/configs/dev'
   case 'TEST': 
     return './kubernetes/configs/test'
   case 'PROD': 
     return './kubernetes/configs/prod'
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

void loadSecrets() {
  container('sbt-container') { // This is required only for kubectl command (sbt is not needed)
    withKubeConfig([credentialsId: 'kube-config']) {
      sh'''
        # Cleanup
        kubectl -n $NAMESPACE delete secrets regcred --ignore-not-found
        kubectl -n default get secret regcred -o yaml | sed s/"namespace: default"/"namespace: $NAMESPACE"/ |  kubectl apply -n $NAMESPACE -f -
      '''

      loadCredentials('storage', 'STORAGE_USR', 'AWS_SECRET_ACCESS_USR', 'STORAGE_PSW', 'AWS_SECRET_ACCESS_PSW')
      loadCredentials('aws', 'AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_USR', 'AWS_SECRET_ACCESS_KEY', 'AWS_SECRET_ACCESS_PSW')
      loadCredentials('postgres', 'POSTGRES_USR', 'POSTGRES_CREDENTIALS_USR', 'POSTGRES_PSW', 'POSTGRES_CREDENTIALS_PSW')
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