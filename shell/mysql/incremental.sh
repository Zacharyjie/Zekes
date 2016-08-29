#!/bin/bash
DIR=/opt/xtrabackup
DATE=`date +%Y%m%d`
FIRSTDAY=`date -d "last monday" +%Y%m%d`
PASSWORD=0ps.iz3n3s0ft
/usr/bin/innobackupex --user=root --defaults-file=/etc/my.cnf --password=$PASSWORD --no-timestamp --incremental-basedir=$DIR/$FIRSTDAY --incremental $DIR/$DATE &>/tmp/back.log
