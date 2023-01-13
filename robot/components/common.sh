LOGFILE=/tmp/$COMPONENT.log

USER_ID=$(id -u)

#validation for root user
if [ $USER_ID -ne 0 ]; then
    echo -e "\e[31m You must execute as a Root User\e[0m"
    exit 1
fi

stat(){
    if [ $1 -eq 0 ]; then
        echo -e "\e[32m Success\e[0m"
    else
        echo -e "\e[31m Failed\e[0m"
    fi
}

NODEJS(){
    echo -n "Installing NodeJS Component"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
    yum install nodejs -y &>> $LOGFILE

    CREATE_USER

    DOWNLOAD_AND_EXTRACT

    NPM_INSTALL

    CONFIGURE_SERVICES
}

CREATE_USER(){
    id $APPUSER &>> $LOGFILE
    if [ $? -ne 0 ]; then
        echo " Creating User "
        useradd $APPUSER &>> $LOGFILE
        stat $?
    fi    
}

DOWNLOAD_AND_EXTRACT(){
    echo -n " Downloading the Zip file"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
    stat $?

    echo -n "Unzipping the file"
    rm -rf /home/$APPUSER/$COMPONENT
    cd /home/$APPUSER
    unzip /tmp/$COMPONENT.zip &>> LOGFILE && mv $COMPONENT-main $COMPONENT
    Stat $?

    echo -n " Changing permissions to $APPUSER"
    chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT &&  chmod -R 775 /home/$APPUSER/$COMPONENT
    stat $?
}

NPM_INSTALL(){
    
    echo -n "Installing Package manager"
    cd /home/$APPUSER/$COMPONENT
    npm install &>> LOGFILE
    stat $?
}

CONFIGURE_SERVICES(){
    echo -n "configuring $COMPONENT service"
    sed -i -e 's/MONGO_DNSNAME/mongodb.robot.internal/' -e 's/MONGO_ENDPOINT/mongodb.robot.internal/' -e 's/REDIS_ENDPOINT/redis.robot.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.robot.internal/' /home/$APPUSER/$COMPONENT/systemd.service
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    $?

    echo -n " starting the service"
    systemctl daemon reload 
    systemctl enable $COMPONENT
    systemctl restart $COMPONENT
    $?
}