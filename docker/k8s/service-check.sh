#!/bin/bash
SERVICE_NAME='SERVICE_NAME'
NAMESPACE='NAMESPACE'
PODS=`kubectl get pods -n ${NAMESPACE} | grep ${SERVICE_NAME} |awk '{print $1}'`
count=130

for ((j=1;j<=6;j++));
do
  for i in $PODS
  do
  DESIRED=`kubectl get pods -n ${NAMESPACE} | grep $i | awk  '{print $2}' | awk -F'/' '{print $2}'`
  CURRENT=`kubectl get pods -n ${NAMESPACE} | grep $i | awk  '{print $2}' | awk -F'/' '{print $1}'`
  STATUS=`kubectl get pods -n ${NAMESPACE} | grep $i | awk '{print $3}'`
    if [ $DESIRED == $CURRENT -a $STATUS == "Running" ]; then
      echo "Pod $i start success******************"
      break;
    else:
      echo "Pod is starting......timeout[$count-10]"
    fi
  done
  sleep 10;
done
