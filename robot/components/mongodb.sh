#!/bin/bash
set -e 

COMPONENT=mongodb
source components/common.sh

echo -n " Setting up the repo for Mongo DB"
curl -s -o /etc/yum.repos.d/$COMPONENT.repo https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/mongo.repo &>> $LOGFILE
stat $?

echo -n "Installing $COMPONENT"
yum install -y $COMPONENT-org &>> $LOGFILE
stat $?

echo -n "Configuring ports"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n "starting the service"
systemctl enable mongod 
systemctl start mongod 
stat $?

echo -n "Downloading the schema"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOGFILE
stat $?

echo -n "unzipping the file"
cd /tmp
unzip -o $COMPONENT.zip &>> $LOGFILE
stat $?

echo -n "Injecting the schema"
cd $COMPONENT-main
mongo < catalogue.js &>> $LOGFILE
mongo < users.js &>> $LOGFILE
stat $?




