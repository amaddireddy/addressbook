#! /bin/bash
sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
sudo yum install maven -y 
if [ -d "address" ] 
then
  echo "repo is cloned and exists"
  cd /home/ec2-user/address
  git pull origin democicd
else
  git clone https://github.com/amaddireddy/address.git
fi
cd /home/ec2-user/address
mvn package  
sudo yum install docker -y
sudo systemctl start docker
