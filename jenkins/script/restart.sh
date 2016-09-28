#!/bin/bash
# @mike @yegucheng

if [ "$1" = "" ]; then
    BASE_DIR=$(pwd)
else
    BASE_DIR=$1
fi

#test shutdown state
STATE=$(ps aux | grep $BASE_DIR | grep -v grep | wc -l)
if [ $STATE -gt 0 ]; then	
    ps aux | grep $BASE_DIR | grep -v grep | awk '{print $2}' | xargs kill -9
    echo "tomcat kill success!"
else
    echo "tomcat $BASE_DIR pid not exsit"
fi

mv logs/catalina.out logs/catalina.last
sh bin/startup.sh
sleep 3

STATE=$(ps aux | grep $BASE_DIR | grep -v grep | wc -l)
if [ $STATE -gt 0 ]; then
    echo "tomcat startup success!"
else
    echo "tomcat startup failed, please check you config!"
fi

echo "[INFO] ---------------------------------------------------------- Show java process status -----------------------------------------------------------------"
ps aux | grep -v grep | grep $BASE_DIR
echo ""
