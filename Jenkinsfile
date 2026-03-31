pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Akshaybahiramwar29/flask-ci-cd-app.git'
            }
        }

        stage('Build') {
            steps {
                sh '''
                python3 -m venv venv
                ./venv/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                ./venv/bin/pytest -v
                '''
            }
        }
          stage('SonarQube Analysis') {
    steps {
        script {
            def scannerHome = tool 'sonar-scanner'
            withSonarQubeEnv('sonarqube') {
                sh """
                ${scannerHome}/bin/sonar-scanner \
                -Dsonar.projectKey=flask-ci-cd-app \
                -Dsonar.projectName=flask-ci-cd-app \
                -Dsonar.sources=app \
                -Dsonar.tests=tests \
                -Dsonar.sourceEncoding=UTF-8
                """
            }
        }
    }
}

        stage('Package') {
            steps {
                sh '''
                tar -czvf flask-ci-cd-app.tar.gz *
                '''
            }
        }
        
        stage('Upload to Nexus') {
            steps {
                sh'''curl -v -u admin:password --upload-file flask-ci-cd-app.tar.gz\
                http://10.xxx.xxx.xxx:8082/repository/flask-artifacts/flask-ci-cd-app.tar.gz'''
            }
        }
        stage('Docker Build') {
          steps {
            sh 'docker build -t akshaybahiramwar/flask-ci-cd-app:1.0.${BUILD_NUMBER} .'
            }
        }
        stage('Docker Login') {
          steps {
            withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
              sh 'echo $PASS | docker login docker.io -u $USER --password-stdin'
        }
    }
}
        stage('Docker Push') {
          steps {
            sh 'docker push akshaybahiramwar/flask-ci-cd-app:1.0.${BUILD_NUMBER}'
        }
    }
        stage('Update K8s Image') {
          steps {
           sh '''sed -i "s|image:.*|image: akshaybahiramwar/flask-ci-cd-app:1.0.${BUILD_NUMBER}|" k8s/deployment.yaml'''
        }
    }
        stage('Deploy to EKS') {
          steps {
            sh """
            aws eks --region us-east-1 update-kubeconfig --name flask-cluster
            kubectl apply -f k8s/deployment.yaml
            kubectl apply -f k8s/service.yaml
            """
          }
        }
    }
}
