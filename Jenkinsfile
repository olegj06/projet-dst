pipeline { 
environment {  // Environnement variables declaration

DOCKER_ID = "olegj06" // replace this with your docker-id
DOCKER_IMAGE1 = "wordpress"
DOCKER_IMAGE2 =  "mariadb"
DOCKER_TAG1 = "v.${BUILD_ID}.0"
DOCKER_TAG2 = "v.${BUILD_ID}.0" // we will tag our images with the current build in order to increment the value by 1 with each new build
}
agent any // Jenkins will be able to select all available agents
stages {
        stage(' Docker Build'){ // docker build image stage
            steps {
                script {
                sh '''
                 docker rm -f jenkins
                 docker build -t $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG1 -f Docker/wordpress/Dockerfile  .
                 docker build -t $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG2 -f Docker/mariadb/Dockerfile .
                 sleep 6

                '''
                }
            }
        }
        stage('Docker run'){ // run container from our builded image
                steps {
                    script {
                    sh '''
                    docker rm -f wordpress
                    docker rm -f mariadb
                    docker run -d -p 3306:3306 --name mariadb $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG2
                    docker run -d -p 8088:80 --name wordpress --link mariadb:database $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG2
                    
                    sleep 10
                    '''
                    }
                }
            }

        stage('Test Acceptance'){ // we launch the curl command to validate that the container responds to the request
            steps {
                    script {
                    sh '''
                    curl -f http://localhost:8088 || exit 1
                    mysqladmin ping -h 127.0.0.1 -u root --password=rootpassword || exit 1
                    '''
                    }
            }

        }
        stage('Docker Push'){ //we pass the built image to our docker hub account
            environment
            {
                DOCKER_PASS = credentials("DOCKER_HUB_PASS") // we retrieve  docker password from secret text called docker_hub_pass saved on jenkins
            }

            steps {

                script {
                sh '''
                docker login -u $DOCKER_ID -p $DOCKER_PASS
                docker push $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG1
                docker push $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG2
                '''
                }
            }

        }

        stage('Deploy to Dev') {
            environment {
                KUBECONFIG = credentials("config") 
            }
            steps {
                script {
                    sh '''
                    rm -Rf .kube
                    mkdir .kube
                    cat $KUBECONFIG > .kube/config
                    cp ./my-charts/values-dev.yml values.yml
                    #helm upgrade --install mariadb ./my-charts --set mariadb.image.tag=${DOCKER_TAG2} --values values.yml --namespace dev                    
                    #helm upgrade --install wordpress ./my-charts --set wordpress.image.tag=${DOCKER_TAG1} --values values.yml --namespace dev
                    helm upgrade --install mariadb ./my-charts \
                    --set mariadb.image.tag=${DOCKER_TAG2} \
                    --values ./my-charts/values-dev.yml \
                    --namespace dev \
                    --install --wait \
                    #--atomic \
                    
                    && helm upgrade --install wordpress ./my-charts \
                        --set wordpress.image.tag=${DOCKER_TAG1} \
                        --values ./my-charts/values-dev.yml \
                        --namespace dev \
                        --install --wait \
                        #--atomic \
                        
                    '''
                }
            }
        }
        stage('Test in Dev') {
            steps {
                script {
                    sh '''
                    kubectl run curl --image=curlimages/curl --rm -it --restart=Never --namespace dev -- curl -f http://wordpress1.dev.svc.cluster.local || exit 1
                    kubectl run mysql --image=mysql:5.7 --rm -it --restart=Never --namespace dev -- mysqladmin ping -h mariadb.dev.svc.cluster.local -u root --password=rootpassword || exit 1
                    '''
                }
            }
        }
}
}