#!/usr/bin/env bash

#? Dig for the WAN IP

WAN_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

GET_WAN_IT() 
{
    echo -e "\n\n\033[0;32m#!#~~~~~~~~~~~~~~~~~~~~\033[0;31m Discovering WAN IP \033[0;32m~~~~~~~~~~~~~~~~~~~~#!#\n\n\033[0m"
    echo -e "\033[0;32m                       WAN IP: \033[0;31m $WAN_IP   \033[0;32m"
    echo -e "\n\n\033[0;32m#!# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #!#\n\n\033[0m"
}

GET_WAN_IT
