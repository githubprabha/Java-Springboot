pipeline {
    agent any 
    // agent {label 'slave'}
    
    tools {
      maven 'maven'
    }
    
    // triggers {
    //   pollSCM('3 * * * *')
    //   cron('2 * * * *')
    // }

    environment {
      SCANNER_HOME = tool 'sonarqube-server'
    }

    stages {

      stage('clean workspace'){
        steps{
          cleanWs ()
        }
      }
      
      stage('git checkout') {
        steps {
          git branch: 'feature', url: 'https://github.com/githubprabha/Java-Springboot.git'
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
            sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=java_webapplication \
              -Dsonar.java.binaries=. \
              -Dsonar.projectKey=java_webapplication'''
          }
        }
      }
      
      // stage('trivy-filescan') {
      //   steps {
      //     script {
      //       sh 'trivy fs --security-checks vuln --severity HIGH,CRITICAL -f json -o file-report.json .'
            
      //     }
      //   }
      // }

      stage('docker-stage-clear') {
        steps {
          sh 'docker stop $(docker ps -q) || true'
          sh 'docker rm $(docker ps -aq) || true'
          sh 'docker rmi $(docker images -q) || true'
        }
      }

      stage('docker-image') {
        steps {
          sh 'docker build -t dockerprabha2001/java-spring .'
        }
      }

      stage('trivy') {
        steps {
          script {
            sh 'trivy image --severity HIGH,CRITICAL -f table -o report.html dockerprabha2001/java-spring'
            
          }
        }
      }

      stage('docker push') {
        steps {
          script {
            withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
              sh 'docker push dockerprabha2001/java-spring'
            }
          }
        }
      }

      stage('docker-container') {
        steps {
          sh 'docker run -itd -p 8081:8080 dockerprabha2001/java-spring'
        }
      }
    }

    post {
        always {
            echo 'slack Notification.'
            slackSend channel: '#java-ci-cd-pipeline',
            message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URl}"  
        }
    }
}
