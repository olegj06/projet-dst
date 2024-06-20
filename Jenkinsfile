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
                 docker rm -f  mariadb
                 docker rm -f  wordpress
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
                docker tag $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG1 $DOCKER_ID/$DOCKER_IMAGE1:latest
                docker push $DOCKER_ID/$DOCKER_IMAGE1:latest

                docker push $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG2
                docker tag $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG2 $DOCKER_ID/$DOCKER_IMAGE2:latest
                docker push $DOCKER_ID/$DOCKER_IMAGE2:latest
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
                                                
                    helm upgrade --install infra ./my-charts \
                    --set mariadb.image.tag=${DOCKER_TAG2} \
                    --set wordpress.image.tag=${DOCKER_TAG1}\
                    --values ./my-charts/values-dev.yml \
                    --namespace dev \
                    
                    

                    sleep 10   
                    '''
                }
            }
        }
        stage('Test in Dev') {
            steps {
                script {
                    sh '''
                    kubectl wait pod \
                    --all \
                    --for=condition=Ready \
                    --namespace dev
                    kubectl run curl --image=curlimages/curl --rm -it --restart=Never --namespace dev -- curl -f http://wordpress.dev.svc.cluster.local || exit 1
                    kubectl run mysql --image=mysql:5.7 --rm -it --restart=Never --namespace dev -- mysqladmin ping -h mariadb.dev.svc.cluster.local -u root --password=rootpassword || exit 1
                    '''
                }
            }
        }

        stage('Deploy to Staging') {
            environment {
                KUBECONFIG = credentials("config") 
            }
            steps {
                script {
                    sh '''
                    rm -Rf .kube
                    mkdir .kube
                    cat $KUBECONFIG > .kube/config
                    helm upgrade --install infra ./my-charts \
                    --set mariadb.image.tag=${DOCKER_TAG2} \
                    --set wordpress.image.tag=${DOCKER_TAG1}\
                    --values ./my-charts/values-staging.yml \
                    --namespace staging \
                   
                        

                    sleep 10 
                    '''
                    
                }
            }
        }

        stage('Test in Staging') {
            steps {
                script {
                    sh '''
                    kubectl wait pod \
                    --all \
                    --for=condition=Ready \
                    --namespace staging

                    kubectl run mysql --image=mysql:5.7 --rm -it --restart=Never --namespace staging -- mysqladmin ping -h mariadb.staging.svc.cluster.local -u root --password=rootpassword || exit 1
                    kubectl run curl --image=curlimages/curl --rm -it --restart=Never --namespace staging -- /bin/sh -c '
                    for i in {1..10}; do
                    echo "Request $i";
                    curl -f http://wordpress.staging.svc.cluster.local || exit 1;
                    done'
                    '''
                }
            }
        }
        
        stage('Initializing Terraform') {
            environment{
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID') 
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
                AWS_DEFAULT_REGION = 'eu-west-3'
            }
            steps{
                script{
                    dir('terraform') {
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Validating Terraform') {
             environment{
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID') 
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
                AWS_DEFAULT_REGION = 'eu-west-3'
            }
            steps{
                script{
                    dir('terraform') {
                        sh '''
                        export TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID
                        export TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY
                        terraform validate -no-color 
                        
                        '''
                    }
                }
            }
        }

        stage('Approving the plan'){
            environment{
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID') 
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
                AWS_DEFAULT_REGION = 'eu-west-3'
            }
            steps{
                script{
                    dir('terraform'){
                         sh '''
                         export TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID
                         export TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY
                         terraform plan 
                         '''
                    }
                    input(message: "Approve?", ok: "proceeding")
                }
            }
        }

        stage('Deploy to prod on AWS EKS'){
            environment {
                KUBECONFIG = credentials("config")
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID') 
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
                AWS_DEFAULT_REGION = 'eu-west-3'
            }
            steps{
                script{
                    dir('terraform'){
                        sh '''
                        export TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID
                        export TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY
                        terraform apply --auto-approve
                        '''
                    }
               
                    sh '''
                    
                    rm -Rf .kube
                    mkdir .kube
                    cat $KUBECONFIG > .kube/config
                    export KUBECONFIG=.kube/config
                    aws eks update-kubeconfig --region eu-west-3 --name ProjetR --kubeconfig .kube/config
                    
    
                    helm upgrade --install infra ./my-charts \
                        --set mariadb.image.tag=${DOCKER_TAG2} \
                        --set wordpress.image.tag=${DOCKER_TAG1}\
                        --values ./my-charts/values-prod.yml \
                        --namespace prod \

                    kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: nginx-ingress
EOF
                    
                    helm repo add nginx-stable https://helm.nginx.com/stable
                    helm repo update

                    helm upgrade --install nginx-ingress nginx-stable/nginx-ingress --set rbac.create=true --namespace nginx-ingress
                    
                    '''
            
                }
            }
        }
}
}
        
    
