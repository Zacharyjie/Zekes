#!/bin/bash
# Program:
#       此程序用于定时切割mysql的慢查询日志！
slowlog=/var/log/mysql/mysql-slow.log
DATE=`date -d '1 day ago' +%Y%m%d`
HOSTNAME=`hostname`
DIR=/home/lscm/slow_log/
mv $slowlog /var/log/mysql/mysql-slow_$DATE.log
mysqladmin -uroot -p123456 --socket=/var/run/mysqld/mysqld.sock flush-logs
echo "******************记录次数最多的10个查询******************">>${DIR}${HOSTNAME}_slow_$DATE.log
mysqldumpslow -s c -t 10 -g "select" /var/log/mysql/mysql-slow_$DATE.log >>${DIR}${HOSTNAME}_slow_$DATE.log
echo "***********************记录查询时间最多的10个查询***************">>${DIR}${HOSTNAME}_slow_$DATE.log
mysqldumpslow -s l -t 10 -g "select" /var/log/mysql/mysql-slow_$DATE.log >>${DIR}${HOSTNAME}_slow_$DATE.log
echo "*********************记录连接查询的语句***************">>${DIR}${HOSTNAME}_slow_$DATE.log
mysqldumpslow -g "join" /var/log/mysql/mysql-slow_$DATE.log >>${DIR}${HOSTNAME}_slow_$DATE.log
echo "*********************记录左连接查询的语句***************">>${DIR}${HOSTNAME}_slow_$DATE.log
mysqldumpslow -g "left join"  /var/log/mysql/mysql-slow_$DATE.log >>${DIR}${HOSTNAME}_slow_$DATE.log
