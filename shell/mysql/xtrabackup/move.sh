#!/bin/bash
DIR=/opt/xtrabackup
DATE=`date +%Y%m%d`
DIR02=/xtrabackup/xtrabackup/xtrabackup/10.30.105.27
rsync -av ${DIR}/${DATE} ${DIR02}/
