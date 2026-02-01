pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Code already checked out from SCM'
            }
        }

        stage('Setup Python Env') {
            steps {
                sh '''
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh '''
                . venv/bin/activate
                pytest -v
                '''
            }
        }
    }
}
