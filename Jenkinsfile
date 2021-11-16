pipeline {
// TODO Can configs be loaded just once globally?

  agent any

  environment {
      AWS_SECRET_ACCESS = credentials('jenkins-aws')
      BRANCH_NAME = "${env.GIT_LOCAL_BRANCH}"
  }

  stages {
      stage('Debug') {
        steps {
            // DELETE ME. Just for testing
            sh 'env'
        }
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

    stage('Create namespace') {
        steps {
            applyKubeFile('namespace.yaml')
        }
    }
    // stage('Create ingresses') {
    //     steps {
    //         applyKubeFile('ingress.yaml')
    //     }
    // }
    // stage('Create roles') {
    //     steps {
    //         applyKubeFile('roles.yaml')
    //     }
    // }
    // stage('Load ConfigMap') {
    //     steps {
    //         applyKubeFile('configmap.yaml')
    //     }
    // }
    // stage('Load Secrets') {
    //     steps {
    //         sh'''
    //         # TODO This could be avoided when using public repository
    //         kubectl get secret regcred -n default --export -o yaml | kubectl apply -n $NAMESPACE -f -

    //         kubectl create secret generic aws --from-literal=AWS_ACCESS_KEY_ID=$AWS_SECRET_ACCESS_USR --from-literal=AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_PSW -n $NAMESPACE
    //         '''
    //     }
    // }
    // stage('Deploy services') {
    //     parallel {
    //         stage('Party Management') {
    //             steps {
    //                 applyKustomizeToDir('kubernetes/overlays/party-management', getServiceNameFromConf("PARTY_MANAGEMENT_SERVICE_NAME"))
    //             }
    //         }
    //     }

    // }
  }
}

void applyKubeFile(String fileName) {
  withKubeConfig([credentialsId: 'kube-config']) {

    echo "Apply file ${fileName} on Kubernetes"

    echo "Compiling file ${fileName}"
    sh './kubernetes/templater.sh ./kubernetes/${fileName} -s -f ./kubernetes/config > ./kubernetes/compiled.${fileName}'
    echo "File ${fileName} compiled"
    
    echo "Applying file ${fileName}"
    sh 'kubectl apply -f ./kubernetes/compiled.${fileName}'
    echo "File ${fileName} applied"
  
  }
}

// dirPath starting from kubernetes folder (e.g. kubernetes/overlays/party-management)
void applyKustomizeToDir(String dirPath, String serviceName) {
  withKubeConfig([credentialsId: 'kube-config']) {

    echo "Apply directory ${dirPath} on Kubernetes"

    sh 'mkdir ${serviceName}'

    echo "Compiling base files"
    compileDir("./kubernetes/base", serviceName)
    echo "Base files compiled"

    echo "Compiling directory ${dirPath}"
    compileDir(dirPath, serviceName)
    echo "Directory ${dirPath} compiled"
    
    echo "Applying Kustomization for ${serviceName}"
    sh '''
    DIR_NAME=$(basename ${dirPath})
    kubectl kustomize ${serviceName}/$DIR_NAME > ${serviceName}/full.${serviceName}.yaml
    '''
    echo "Kustomization for ${serviceName} applied"

    echo "Applying files for ${serviceName}"
    sh 'kubectl apply -f ${serviceName}/full.${serviceName}'
    echo "Files for ${serviceName} applied"

    echo "Removing folder"
    sh 'rm -rf ${serviceName}'
    echo "Folder removed"
  }

}

void compileDir(String dirPath, String serviceName) {
  sh 'cp -rf ${dirPath} ./${serviceName}'
  sh '''
  DIR_NAME=$(basename ${dirPath})
  BASE_FILES_PATH="${serviceName}/$DIR_NAME"
  for f in $BASE_FILES_PATH/*
  do
      if [ ! $(basename $f) = "kustomization.yaml" ]
        then
          SERVICE_NAME=${serviceName} ./kubernetes/templater.sh $f -s -f ./kubernetes/config > ./${serviceName}/$DIR_NAME/compiled.$(basename $f)
      fi
  done
  '''
}

String getServiceNameFromConf(String variableName) {
  return sh (returnStdout: true, script: './kubernetes/config && echo $${variableName}').trim()
}