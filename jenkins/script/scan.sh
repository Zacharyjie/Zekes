#!/bin/bash
#scan code 

CodePath=/usr/local/websrv/jenkins/jenkinsworkspace/online/.jenkins/workspace
LOG=/tmp/scan.log

echo $1 > $LOG

if [ -d /usr/local/websrv/jenkins/jenkinsworkspace/online/.jenkins/workspace/$1/src ]; then
#JAVA
    grep "http://" -R $CodePath/$1/src/* | grep -v "www.w3.org" | grep -v "java.sun.com" | grep -v "b5m.com" | grep -v "bang5mai.com" | grep -v "live800.com" | grep -v "springframework.org" | grep -v "jfree.org"| grep -v "xmlsoap.org"| awk -F "/$1/" '{print $NF}' >> $LOG
else

#PHP STATIC
    grep "http://" -R $CodePath/$1/* | grep -v "www.w3.org" | grep -v "java.sun.com" | grep -v "b5m.com" | grep -v "bang5mai.com" | grep -v "live800.com"  | grep -v "springframework.org" | grep -v "jfree.org"| awk -F "/$1/" '{print $NF}' >> $LOG
fi

#move bi
scp $LOG lscm@10.30.100.22:/data/scan_dir/$1-scan-`date +%F-%T`
