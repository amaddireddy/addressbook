pipeline {
    agent none
    tools{
        jdk 'myjava'
        maven 'mymaven'
    }    
     stages {
        stage('COMPILE') {
            agent any
            steps {
                script{
                    echo "COMPILING THE CODE"
                    git 'https://github.com/amaddireddy/addressbook.git'
                    sh 'mvn compile'
                }
                          }
            }
        stage('UNITTEST'){ 
            agent any                   
            steps {
                script{
                  echo "RUNNING THE UNIT TEST CASES"
                  sh 'mvn test'
                }
             
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
            }

        stage('PACKAGE+BUILD DOCKER IMAGE ON BUILD SERVER'){
            agent any               
           steps{
                script{
            sshagent(['Test_server-Key']) {
        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    echo "PACKAGING THE CODE" 
                    sh "scp -o StrictHostKeyChecking=no server-script.sh ec2-user@172.31.7.163:/home/ec2-user"
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@172.31.7.163 'bash ~/server-script.sh'" 
                    sh "ssh ec2-user@172.31.7.163 sudo docker build -t amaddireddy/newimage:$BUILD_NUMBER /home/ec2-user/addressbook"
                   sh "ssh ec2-user@172.31.7.163 sudo docker login -u $USERNAME -p $PASSWORD" 
                   sh "ssh ec2-user@172.31.7.163 sudo docker push amaddireddy/newimage:$BUILD_NUMBER"
                    }
                    }
                }          
            } 
        }
        stage('DEPLOY ON DEPLOY SERVER'){
            agent any
                steps{
                    script{
                         sshagent(['Test_server-Key']) {
                             withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) { 
                             sh "ssh ec2-user@172.31.7.163 sudo docker run -itd -P amaddireddy/newimage:$BUILD_NUMBER"                       
                    }
                         }
                }
            }               
                 }        
    }
}   
