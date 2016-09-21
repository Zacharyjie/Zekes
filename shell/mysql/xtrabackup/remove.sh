#!/bin/bash
DIR=/opt/xtrabackup
DATE=`date +%Y%m%d`
DIR02=/opt/xtrabackup02
tar zcvf $DIR02/databack_$DATE.tar $DIR/* --remove-files 

find $DIR02/ -name "*.tar" -mtime +30 -exce  rm -rf {} \;
