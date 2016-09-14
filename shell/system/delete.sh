#!/bin/bash

set -e 

SHUZI=`df -h | grep /dev/sda3 | awk '{print $5}' | cut -c-2`
PATH=/opt/logserver
PATHD=prod-log-server-elasticsearch/nodes/0/indices/
MONTH=`/bin/date -d "1 month ago" +"%Y-%m"`
MONTHD=`/bin/date -d "2 month ago" +"%Y.%m"`
NUMBER=(10 11 12 13 14)

if [ $SHUZI -ge 80 ]
then
for i in ${NUMBER[@]};
do
  cd $PATH/data-n00$i/logs/
  /bin/ls | /bin/grep $MONTH
  #/bin/rm -irf `/bin/ls |/bin/grep $MONTH`
  #prod路径
  cd $PATH/data-n00$i/$PATHD
  /bin/ls | /bin/grep $MONTHD >> /dev/dull
  #/bin/rm -irf `/bin/ls |/bin/grep $MONTHD`
done
fi

