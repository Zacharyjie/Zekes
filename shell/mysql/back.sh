#!/bin/bash
DIR=/opt/xtrabackup
DATE=`date +%Y%m%d`
PASSWORD=0ps.iz3n3s0ft
/usr/bin/innobackupex --user=root --defaults-file=/etc/my.cnf --password=$PASSWORD --no-timestamp $DIR/$DATE &>/tmp/back.log
