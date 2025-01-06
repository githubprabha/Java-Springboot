pipeline {
    agent any 
    
    tools {
        maven 'maven'
    }
    
    environment {
        SCANNER_HOME = tool 'sonarqube-server'
    }

    stages {
        stage('clean workspace') {
            steps {
                cleanWs()
            }
        }
        
        stage('git checkout') {
            steps {
                git 'https://github.com/githubprabha/Java-Springboot.git'
            }
        }
        
        stage('compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('code analysis') {
            steps {
                withSonarQubeEnv('sonarqube-scanner') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Java-Springboot \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=Java-Springboot'''
                }
            }
        }
        
        stage('docker-stage-clear') {
            steps {
                sh 'docker stop $(docker ps -q) || true'
                sh 'docker rm $(docker ps -aq) || true'
                sh 'docker rmi $(docker images -q) || true'
            }
        }

        stage('docker-image') {
            steps {
                sh 'docker build -t dockerprabha2001/javaspring .'
            }
        }

        stage('trivy') {
            steps {
                script {
                    sh 'trivy image --severity HIGH,CRITICAL -f table -o report.html dockerprabha2001/javaspring'
                }
            }
        }

        stage('docker push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh 'docker push dockerprabha2001/javaspring'
                    }
                }
            }
        }

        stage('docker-container') {
            steps {
                sh 'docker run -itd -p 8081:8080 dockerprabha2001/javaspring'
            }
        }
    }

    post {
        always {
            echo 'Slack Notification.'
            slackSend(
                channel: '#java-ci-cd-pipeline',
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
            )
        }
    }
}
