pipeline {
// TODO Can configs be loaded just once globally?

  agent any

  environment {
    AWS_SECRET_ACCESS = credentials('jenkins-aws')
    NAMESPACE = "${env.GIT_LOCAL_BRANCH}"
  }

  stages {
    stage('Platform') {
      // This is required only for kubectl command (we do not need sbt)
      agent { 
        label 'sbt-template' 
      }
      // stage('Initializing build') {
      //   agent { label 'sbt-template' }
      //   environment {
      //     PDND_TRUST_STORE_PSW = credentials('pdnd-interop-trust-psw')
      //   }
      //   steps {
      //     withCredentials([file(credentialsId: 'pdnd-interop-trust-cert', variable: 'pdnd_certificate')]) {
      //       sh '''
      //         cat \$pdnd_certificate > pdnd_certificate.cer
      //         keytool -import -file pdnd_certificate.cer -alias pdnd-interop-gateway -keystore PDNDTrustStore -storepass ${PDND_TRUST_STORE_PSW} -noprompt
      //         cp $JAVA_HOME/jre/lib/security/cacerts main_certs
      //         keytool -importkeystore -srckeystore main_certs -destkeystore PDNDTrustStore -srcstorepass ${PDND_TRUST_STORE_PSW} -deststorepass ${PDND_TRUST_STORE_PSW}
      //       '''
      //       stash includes: "PDNDTrustStore", name: "pdnd_trust_store"
      //     }
      //   }
      // }
      stages {

        stage('Debug') {
          steps {
              // DELETE ME. Just for testing
              sh 'env'
          }
        }
        
        stage('Create Namespace') {
          steps {
              applyKubeFile('namespace.yaml')
          }
        }
        stage('Create Ingress') {
          steps {
              applyKubeFile('ingress.yaml')
          }
        }
        stage('Create Roles') {
          steps {
              applyKubeFile('roles.yaml')
          }
        }
        stage('Load ConfigMap') {
          steps {
              applyKubeFile('configmap.yaml')
          }
        }
        stage('Load Secrets') {
          steps {
              loadSecrets()
          }
        }
        stage('Deploy Services') {
          parallel {
            stage('Party Management') {
                steps {
                    applyKustomizeToDir('kubernetes/overlays/party-management', getVariableFromConf("PARTY_MANAGEMENT_SERVICE_NAME"))
                }
            }
          }
        }
      }
    }
  }
}

void applyKubeFile(String fileName) {
  container('sbt-container') { // This is required only for kubectl command (we do not need sbt)
    withKubeConfig([credentialsId: 'kube-config']) {

      echo "Apply file ${fileName} on Kubernetes"

      echo "Compiling file ${fileName}"
      sh "./kubernetes/templater.sh ./kubernetes/${fileName} -s -f ./kubernetes/config > ./kubernetes/compiled.${fileName}"
      echo "File ${fileName} compiled"
      
      echo "Applying file ${fileName}"
      sh "kubectl apply -f ./kubernetes/compiled.${fileName}"
      echo "File ${fileName} applied"
    
    }
  }
}

// dirPath starting from kubernetes folder (e.g. kubernetes/overlays/party-management)
void applyKustomizeToDir(String dirPath, String serviceName) {
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

    echo "Applying files for ${serviceName}"
    sh "kubectl apply -f ${serviceName}/full.${serviceName}"
    echo "Files for ${serviceName} applied"

    echo "Removing folder"
    sh "rm -rf ${serviceName}"
    echo "Folder removed"
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
          SERVICE_NAME=''' + serviceName + ' ./kubernetes/templater.sh $f -s -f ./kubernetes/config > ./' + serviceName + '''/$DIR_NAME/compiled.$(basename $f)
      fi
  done
  '''
}

String getVariableFromConf(String variableName) {
  sh'chmod +x ./kubernetes/config && ./kubernetes/config && echo $' + variableName
  sh'env'
  return sh (returnStdout: true, script: 'chmod +x ./kubernetes/config && ./kubernetes/config && echo $' + variableName).trim()
}

void loadSecrets() {
  container('sbt-container') { // This is required only for kubectl command (sbt is not needed)
    withKubeConfig([credentialsId: 'kube-config']) {
      sh'''
        
        # TODO This could be avoided when using public repository
        # Cleanup
        kubectl -n $NAMESPACE delete secrets regcred
        kubectl -n default get secret regcred -o yaml | sed s/"namespace: default"/"namespace: $NAMESPACE"/ |  kubectl apply -n $NAMESPACE -f -

        # It allows to update secret if already exists
        kubectl -n $NAMESPACE create secret generic aws \
          --save-config \
          --dry-run=client \
          --from-literal=AWS_ACCESS_KEY_ID=$AWS_SECRET_ACCESS_USR \
          --from-literal=AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_PSW \
          -o yaml | kubectl apply -f -
      '''
    }
  }
}