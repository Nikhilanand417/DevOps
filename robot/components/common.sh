LOGFILE =/tmp/$COMPONENT.log
USER_ID =$(uid -u)

#validation for root user
if[ $USER_ID -ne 0 ] ;then
    echo -e "\e[31m You must execute as a Root User\e[0m"
    exit 1
fi

stat(){
    if [ $1 -eq 0 ] ; then
        echo -e "\e[32m Success\e[0m"
    else
        echo -e "\e[31m Failed\e[0m"
    fi
}