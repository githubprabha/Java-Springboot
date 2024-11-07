def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger'
    ]
pipeline {
    agent any
    tools {
    maven 'maven'
  }
     environment {
        SCANNER_HOME = tool 'sonarqube'
    }
    stages {
        stage('git checkout') {
            steps {
            git 'https://github.com/githubprabha/Java-Springboot'
            }
        }
         stage('compile') {
            steps {
              sh 'mvn compile'
            }
        }
         stage('code analysis') {
            steps {
              withSonarQubeEnv('sonarqube') {
               sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Java-Springboot \
               -Dsonar.java.binaries=. \
               -Dsonar.projectKey=Java-Springboot'''
              }
            }
        }
        stage('package') {
            steps {
              sh 'mvn install'
            }
        }
         stage('docker build') {
            steps {
             script {
                 withDockerRegistry(credentialsId: 'docker-key', toolName: 'docker') {
                    sh 'docker build -t java-spring .'
                  }
              }
            }
        }
         stage('docker push') {
            steps {
             script {
                withDockerRegistry(credentialsId: 'docker-key', toolName: 'docker') {
                    sh 'docker tag java-spring dockerprabha2001/java-spring'
                    sh 'docker push dockerprabha2001/java-spring'
                  }
              }
            }
         }    
        stage('docker container') {
            steps {
             script {
                   withDockerRegistry(credentialsId: 'docker-key', toolName: 'docker') {
                    sh 'docker run -itd --name javaspring-cont -p 8085:8085 java-spring'
                  }
              }
            }
        }    
    }	
 
    post {
        always {
            echo 'slack Notification.'
            slackSend channel: '#basic-practicess',
            color: COLOR_MAP [currentBuild.currentResult],
            message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URl}"
            
        }
    }
}
