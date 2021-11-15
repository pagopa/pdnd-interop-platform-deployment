pipeline {

  agent none

  environment {
      AWS_SECRET_ACCESS = credentials('jenkins-aws')
      BRANCH_NAME = env.CHANGE_BRANCH
  }

  stages {
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

    withKubeConfig([credentialsId: 'kube-config']) {
        stage('Create namespace') {
            steps {
                applyKubeFile('namespace.yaml')
            }
        }
        stage('Create ingresses') {
            steps {
                applyKubeFile('ingress.yaml')
            }
        }
        stage('Create roles') {
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
                sh'''
                # TODO This could be avoided when using public repository
                kubectl get secret regcred -n default --export -o yaml | kubectl apply -n $NAMESPACE -f -

                kubectl create secret generic aws --from-literal=AWS_ACCESS_KEY_ID=$AWS_SECRET_ACCESS_USR --from-literal=AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_PSW -n $NAMESPACE
                '''
            }
        }
        stage('Deploy services') {
            parallel {
                stage('Party Management') {
                    stage('Deployment') {
                        steps {
                            applyKubeFile('deployment-party-management.yaml')
                        }
                    }
                    stage('Service') {
                        steps {
                            applyKubeFile('service-party-management.yaml')
                        }
                    }
                }
                // stage('Agreement Management') {
                //     stage('Deployment') {
                //         steps {
                //             applyKubeFile('deployment-agreement-management.yaml')
                //         }
                //     }
                //     stage('Service') {
                //         steps {
                //             applyKubeFile('service-agreement-management.yaml')
                //         }
                //     }
                // }
            }
            

        //   agent { label 'sbt-template' }
        //   environment {
        //     DOCKER_REPO = 'gateway.interop.pdnd.dev'
        //     AWS_SECRET_ACCESS = credentials('jenkins-aws')
        //     REPLICAS_NR = 3
        //   }
        //   steps {
        //     container('sbt-container') {
        //       withKubeConfig([credentialsId: 'kube-config']) {
        //         sh '''
        //           cd kubernetes
        //           chmod u+x undeploy.sh
        //           chmod u+x deploy.sh
        //           ./undeploy.sh
        //           ./deploy.sh
        //         '''
        //       }
        //     }
        //   }
        }
    }
  }
}

void applyKubeFile(String fileName) {
  echo "Apply file ${fileName} on Kubernetes"

// TODO Can configs be loaded just once?
  echo "Compiling file ${fileName}"
  sh './kubernetes/templater.sh ./kubernetes/${fileName} -s -f ./kubernetes/config > ./kubernetes/compiled.${fileName}'
  echo "File ${fileName} compiled"
  
  echo "Apply file ${fileName}"
  sh 'kubectl apply -f ./kubernetes/compiled.${fileName}'
  echo "File ${fileName} applied"

}

