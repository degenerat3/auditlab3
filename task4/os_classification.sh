#!/bin/bash

# Develop  an  OS  classification  tool \
# which  differentiates  between  Windows and  Linux without performing a port scan using TTL


# check the number of arguments
if [ "$#" != "1" ]
then
    echo "USAGE: ./os_classification.sh <file>"
    exit 
fi

FILE="$1"
IPS=`cat $FILE`

# Loop through each of the IP addresses in the file
for IP in $IPS;
    do
        # ping the IP address to get the TTL value
        #define variables for various TTLs
        WIN="128" #Windows
        BSD="64" #FreeBSD
        NIX="255" #Linux

        # get the TTL
        TTL=$(ping -c1 $IP | grep -o 'ttl=[0-9][0-9]*' | awk -F"=" '{print $2}')

        case $TTL in
                $WIN)  #check if TTL matches Windows Variable
                    echo "[*] Host: $i OS: Windows";;
                $BSD) #check if TTL matches Linux Variable
                    echo "[*] Host: $i OS: freeBSD";;
                $NIX) #Check if TTL matches freeBSD variable
                    echo "[*] Host: $i OS: Linux";;
        esac
    done
