#!/bin/bash

a=10
b=20
echo -e "Line1"\t"Line 2"
Sample(){
    echo -e "\e[32m $a\e[0m" "\e[32m $b\e[0m"
}


Sample