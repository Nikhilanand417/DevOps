#!/bin/bash
set -e

COMPONENT=$COMPONENT
source components/common.sh

echo -n "Setting up $COMPONENT Repo"
curl -L https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/$COMPONENT.repo -o /etc/yum.repos.d/$COMPONENT.repo &>> $LOGFILE
stat $?

echo -n " Installing $COMPONENT"
yum install $COMPONENT-6.2.7 -y &>> $LOGFILE
stat $?

echo -n "Updating the Band IP of $COMPONENT"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPONENT/$COMPONENT.conf &>> $LOGFILE
stat $?

echo -n " starting the service " 
systemctl enable $COMPONENT
systemctl start $COMPONENT
stat $?