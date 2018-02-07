#!/bin/bash
DATE=`date +%Y%m%d`
BAKDIR='/opt/databak'
PASSWORD='123456'
DATABASE=`mysql -u root -p$PASSWORD -e 'show databases;'|sed  '1d'|grep -v "schema"|grep -v "mysql"|grep -v "test"`
for i in ${DATABASE}
do
mysqldump -u root -p${PASSWORD} --master-data=2 --single-transaction $i |gzip >${BAKDIR}/${i}_${DATE}.sql.gz
if [ $? -eq 0 ];then
DATE02=`date +'%Y%m%d %T'`
echo ${DATE02} >>/opt/log/${DATE}_bakup.log
echo **************the $i is bakup secessfull!!*********>>/opt/log/${DATE}_bakup.log
else
echo ${DATE02} >>/opt/log/${DATE}_error.log
echo -------------the $i bakup error!!!----------->>/opt/log/${DATE}_error.log
exit
fi
done
