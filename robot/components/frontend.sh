#!/bin/bash

set -e 

Component = frontend
source = components/common.sh


echo -n " Installing Nginx"
yum install nginx -yum &>> $LOGFILE
stat $?

echo -n " Downloading Nginx"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

echo -n " Cleaning the directory "
cd /usr/share/nginx/html
rm -rf *
stat $?

echo -n " Deploying in default location"
unzip /tmp/frontend.zip &>> $LOGFILE
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md $LOGFILE
stat $?

echo -n " configuring proxy "
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -n "starting the service"
systemctl enable nginx
systemctl start nginx
stat $?

