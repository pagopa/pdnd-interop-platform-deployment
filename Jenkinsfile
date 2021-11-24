pipeline {
// TODO Can configs be loaded just once globally?

  agent any

  environment {
    // STAGE variable should be set as Global Properties
    STAGE = "${env.STAGE}"
    // AWS_SECRET_ACCESS = credentials('jenkins-aws')
    // TODO Create one set of credentials for each service for production
    // POSTGRES_CREDENTIALS = credentials('postgres-db')
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
            // withEnv(readFile('./kubernetes/config').split('\n') as List) {
            //   sh 'env'
            // }
            // sh"""
            // #!/bin/bash
            // chmod +x ./kubernetes/config
            // ./kubernetes/config
            // echo "VARIABLE:"
            // echo \$PARTY_MANAGEMENT_SERVICE_NAME
            // env
            // """
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
        // stage('Load Secrets') {
        //   steps {
        //       loadSecrets()
        //   }
        // }
        stage('Deploy Services') {
          parallel {
            // stage('Party Management') {
            //   steps {
            //       // applyKustomizeToDir('kubernetes/overlays/party-management', getVariableFromConf("PARTY_MANAGEMENT_SERVICE_NAME"))
            //       applyKustomizeToDir('kubernetes/overlays/party-management', 'pdnd-interop-uservice-party-management')
            //   }
            // }
            // stage('Catalog Process') {
            //   steps {
            //       // applyKustomizeToDir('kubernetes/overlays/catalog-process', getVariableFromConf("CATALOG_PROCESS_SERVICE_NAME"))
            //       applyKustomizeToDir('kubernetes/overlays/catalog-process', 'pdnd-interop-uservice-catalog-process')
            //   }
            // }

            stage('Spid') {
              environment {
                // IDP_SAML_CERT = credentials('idp-saml-cert')
                // IDP_SAML_KEY = credentials('idp-saml-key')
                // IDP_HTTP_CERT = credentials('idp-http-cert')
                // IDP_HTTP_KEY = credentials('idp-http-key')
                
                SPID_LOGIN_SAML_CERT = credentials('spid-login-saml-cert')
                SPID_LOGIN_SAML_KEY = credentials('spid-login-saml-key')
                SPID_LOGIN_JWT_PRIVATE_KEY = credentials('spid-login-jwt-private-key')

                // SPID_LOGIN_METADATA_PUBLIC_CERT = credentials('spid-login-metadata-public-cert')
                // SPID_LOGIN_METADATA_PRIVATE_KEY = credentials('spid-login-metadata-private-key')
                // SPID_LOGIN_JWT_PRIVATE_KEY = credentials('spid-login-jwt-private-key')
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
      outputFile=sh (returnStdout: true, script: 'echo $(dirname ' + fileName + ')/compiled.$(basename ' + fileName + ')').trim()

      echo "Compiling file ${fileName}"
      sh "SERVICE_NAME=" + serviceName + " ./kubernetes/templater.sh ./kubernetes/${fileName} -s -f ${env.CONFIG_FILE} > ./kubernetes/${outputFile}"
      echo "File ${fileName} compiled"
      
      // DEBUG
      sh "cat ./kubernetes/${outputFile}"

      echo "Applying file ${fileName}"
      sh "kubectl apply -f ./kubernetes/${outputFile}"
      echo "File ${fileName} applied"

    }
  }
}

// dirPath starting from kubernetes folder (e.g. kubernetes/overlays/party-management)
void applyKustomizeToDir(String dirPath, String serviceName) {
  container('sbt-container') { // This is required only for kubectl command (we do not need sbt)
    withKubeConfig([credentialsId: 'kube-config']) {

      echo "Apply directory ${dirPath} on Kubernetes"

      sh "mkdir ${serviceName}"

      echo "Compiling base files"
      compileDir("./kubernetes/base", serviceName)
      echo "Base files compiled"

      echo "Compiling directory ${dirPath}"
      compileDir(dirPath, serviceName)
      echo "Directory ${dirPath} compiled"
      
      echo "Applying Kustomization for ${serviceName}"
      sh '''
      DIR_NAME=$(basename ''' + dirPath + ''')
      kubectl kustomize ''' + serviceName + '/$DIR_NAME > ' + serviceName + '/full.' + serviceName + '.yaml'
      echo "Kustomization for ${serviceName} applied"

      // DEBUG
      sh "cat ${serviceName}/full.${serviceName}.yaml"

      echo "Applying files for ${serviceName}"
      sh "kubectl apply -f ${serviceName}/full.${serviceName}.yaml"
      echo "Files for ${serviceName} applied"

      // TODO Uncomment this when ready
      // echo "Waiting for completion of ${fileName}..."
      // sh "kubectl wait -f ./kubernetes/compiled.${fileName} --for condition=Ready --timeout=60s" // TODO Use parameter
      // echo "Apply of ${fileName} completed"

      echo "Removing folder"
      sh "rm -rf ${serviceName}"
      echo "Folder removed"
    }
  }
}

void compileDir(String dirPath, String serviceName) {
  sh "cp -rf ${dirPath} ./${serviceName}"
  // Compile each file in the directory (skipping kustomization.yaml)
  sh '''
  DIR_NAME=$(basename ''' + dirPath + ''')
  BASE_FILES_PATH="''' + serviceName + '''/$DIR_NAME"
  for f in $BASE_FILES_PATH/*
  do
      if [ ! $(basename $f) = "kustomization.yaml" ]
        then
          SERVICE_NAME=''' + serviceName + ' ./kubernetes/templater.sh $f -s -f ' + env.CONFIG_FILE + ' > ./' + serviceName + '''/$DIR_NAME/compiled.$(basename $f)
      fi
  done
  '''
}

// String getVariableFromConf(String variableName) {
//   return sh (returnStdout: true, script: "chmod +x ${env.CONFIG_FILE} && ${env.CONFIG_FILE} && echo $" + variableName).trim()
// }

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

void loadSecrets() {
  container('sbt-container') { // This is required only for kubectl command (sbt is not needed)
    withKubeConfig([credentialsId: 'kube-config']) {
      sh'''
        
        # TODO This could be avoided when using public repository
        # Cleanup
        kubectl -n $NAMESPACE delete secrets regcred --ignore-not-found
        kubectl -n default get secret regcred -o yaml | sed s/"namespace: default"/"namespace: $NAMESPACE"/ |  kubectl apply -n $NAMESPACE -f -

        # It allows to update secret if already exists
        kubectl -n $NAMESPACE create secret generic aws \
          --save-config \
          --dry-run=client \
          --from-literal=AWS_ACCESS_KEY_ID=$AWS_SECRET_ACCESS_USR \
          --from-literal=AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_PSW \
          -o yaml | kubectl apply -f -

        kubectl -n $NAMESPACE create secret generic postgres \
          --save-config \
          --dry-run=client \
          --from-literal=POSTGRES_USR=$POSTGRES_CREDENTIALS_USR \
          --from-literal=POSTGRES_PSW=$POSTGRES_CREDENTIALS_PSW \
          -o yaml | kubectl apply -f -

       # TODO This is temporary. No existing storage credentials yet
        kubectl -n $NAMESPACE create secret generic storage \
          --save-config \
          --dry-run=client \
          --from-literal=STORAGE_USR=user_placeholder \
          --from-literal=STORAGE_PSW=password_placeholder \
          -o yaml | kubectl apply -f -
      '''
    }
  }
}


void loadSpidSecrets() {
  container('sbt-container') { // This is required only for kubectl command (sbt is not needed)
    withKubeConfig([credentialsId: 'kube-config']) {
      // #  --from-literal=METADATA_PUBLIC_CERT="$SPID_LOGIN_METADATA_PUBLIC_CERT" \
      //   #  --from-literal=METADATA_PRIVATE_CERT="$SPID_LOGIN_METADATA_PRIVATE_KEY" \
        
      
      sh'''
        
        kubectl -n $NAMESPACE create secret generic spid-login \
          --save-config \
          --dry-run=client \
          --from-file=METADATA_PUBLIC_CERT="$SPID_LOGIN_SAML_CERT" \
          --from-file=METADATA_PRIVATE_CERT="$SPID_LOGIN_SAML_KEY" \
          --from-file=JWT_TOKEN_PRIVATE_KEY="$SPID_LOGIN_JWT_PRIVATE_KEY" \
          -o yaml | kubectl apply -f -

        #kubectl -n $NAMESPACE create secret generic idp-saml-certs \
        #  --save-config \
        #  --dry-run=client \
        #  --from-file=idp.crt=$IDP_SAML_CERT \
        #  --from-file=idp.key=$IDP_SAML_KEY \
        #  -o yaml | kubectl apply -f -

        #  --from-file=certificate.crt=$IDP_HTTP_CERT \
        #  --from-file=certificate.pem=$IDP_HTTP_KEY \
          
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