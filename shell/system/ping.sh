#!/bin/bash
 
set -e
set -o pipefail

NETWORK=$1
YESTERDAY=$(date -d yesterday +%Y-%m-%d)
for HOST in $(seq 1 16)
do
    /usr/bin/ping -c1 -w1 $NETWORK.$HOST &>/dev/null && RESULT=0 || RESULT=1
        if [ "$RESULT" == 0 ];then
            echo -e "\033[32;1m$NETWORK.$HOST is up \033[0m"
            echo "$NETWORK.$HOST" >> /shell/$YESTERDAY-UP.txt
        else
            echo -e "\033[;31m$NETWORK.$HOST is down \033[0m"
            echo "$NETWORK.$HOST" >> /shell/$YESTERDAY-DOWN.txt
        fi
done
