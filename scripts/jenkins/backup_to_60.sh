#!/bin/bash
#$1 basepath
#$2 job_name
#$3 project name
#$4 huanjing
#$5 xiangmu huanjing
#$6 tomcat_path

#backup to 10.30.99.60
DATE=$(date +%Y%m%d%H%M)
ssh 10.30.99.60 -t "cd /data/code-backup/tomcat_ucenter_8981 && mkdir -p $(date +%Y%m%d%H%M)"

#scp 10.30.99.60:data/code-backup/tomcat_ucenter_8981/$DATE/*

if [ $6 == "online" ]; then
    if [ $7 == "java" ]; then
        scp -r $1/jenkins/jenkinsworkspace/online/.jenkins/workspace/$2/target/$4 lscm@10.30.99.60:/data/code-backup/$5/$DATE/*
    else
        scp -r $1/jenkins/jenkinsworkspace/online/.jenkins/workspace/$2/* lscm@10.30.99.60:/data/code-backup/$5/$DATE/*
    fi
fi
