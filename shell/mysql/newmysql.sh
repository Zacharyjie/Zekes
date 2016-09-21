#!/bin/bash

set -e

MYSQL_USER='root'
MYSQL_PWD='123456'
MYSQL_HOST='172.16.100.100'
MYSQL_PORT='3306'
MYSQL_CONN="/usr/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT}"
MYSQL_CONND="/usr/bin/mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT}"

case $1 in 
    threads) 
        result=`${MYSQL_CONN} status | cut -f3 -d":"|cut -f1 -d"Q"`
        echo $result 
        ;; 
    slave) 
        result=`${MYSQL_CONN} extended-status | grep -w "Slave_running" | cut -d"|" -f3` 
        echo $result 
        ;; 
    slavedelay) 
        result=`${MYSQL_CONND} -e 'SHOW SLAVE STATUS\G' | grep -w "Seconds_Behind_Master" | cut -d":" -f2`
        echo $result 
		;;
    ping) 
        result=`${MYSQL_CONN} ping | cut -c11-15`
        echo $result 
		;;
        *) 
        echo "Usage:$0(threads|slave|slavedelay|ping)" 
        ;; 
esac
