#!/bin/bash

a=10
b=20
c=$1
Today="$(date +%F)"
Load="$(uptime | awk -F : '{print $NF}' | awk -F , '{print $3}')"
Sample(){
    
    echo -e "\e[33m Todays date is $Today\e[0m"
}

Sample
echo $$

read -p 'Enter the name': name 
echo "name is $name"

echo "The load average of the server is $Load"

case $Load in
    >1)
    echo "reached max load"
    ;;
    <1)
    echo "good condition"
esac