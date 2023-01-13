#!/bin/bash

set -e 

COMPONENT=frontend

source  components/common.sh

echo -n " Installing Nginx"
yum install nginx -y &>> $LOGFILE
stat $?

echo -n " Downloading Nginx"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n " Cleaning the directory "
cd /usr/share/nginx/html
rm -rf *
stat $?

echo -n " Deploying in default location"
unzip /tmp/$COMPONENT.zip &>> $LOGFILE
mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md &>> $LOGFILE
stat $?

echo -n " configuring proxy "
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
stat $?

echo -n "starting the service"
systemctl enable nginx
systemctl start nginx
stat $?

