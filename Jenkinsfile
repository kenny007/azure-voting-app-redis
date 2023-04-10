pipeline {
    agent any

    stages {
        stage('Verify Branch') {
            steps {
                sh "echo $GIT_BRANCH"
            }
        }

        stage('Docker Build') {
            steps {
                sh(script: 'docker images -a')
                sh(script: '''
                   cd azure-vote/
                   docker images -a
                   docker build -t jenkins-pipeline .
                   docker images  -a
                   cd ..
                ''')
            }
        }

        stage('Stop and remove containers') {
            steps {
                sh 'docker-compose down'
            }
        }

        stage('Start test app') {
            steps {
                sh(script: '''
             docker-compose up -d
             chmod +x ./scripts/test_container.sh
             ./scripts/test_container.sh
            ''')
            }
            post {
                success {
                    echo 'App started successfully :)'
                }
                failure {
                    echo 'App failed to start :('
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh(script: '''
                python3 -m venv venv
                . venv/bin/activate
                pip install -r requirements.txt
                ''')
            }
        }

        stage('Run Tests') {
            steps {
                sh(script: '''
                . venv/bin/activate
                chmod +x /home/ubuntu/.local/bin/pytest
                /home/ubuntu/.local/bin/pytest ./tests/test_sample.py
                ''')
            }
        }
        stage('Stop test app') {
            steps {
                sh(script: '''
                 docker-compose down
                ''')
            }
        }
        stage('Push container') {
            steps {
                echo "Workspace is $WORKSPACE"
                dir("$WORKSPACE/azure-vote") {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'DockerHub') {
                            def image = docker.build('kennymore/jenkins-tut:latest')
                            image.push()
                        }
                    }
                }
            }
        }
    }
}
