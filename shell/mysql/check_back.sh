#!/bin/bash
if [ -e /opt/xtrabackup/back.log ];then 
tail -1 /opt/xtrabackup/back.log|grep 'completed OK!' &> /dev/null
if [ $? == 0 ];then
echo '1'
else
echo '0'
fi
else
echo '0'
touch /opt/xtrabackup/back.log
fi
