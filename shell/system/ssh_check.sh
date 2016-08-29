#!/bin/bash
#add ip hosts.deny 

DEFINE=30
VAR=`cat /var/log/secure | awk '/Failed/{print $(NF-3)}' | sort | uniq -c | awk '{print $2"="$1;}' `
for loop in $VAR; do
	IP=`echo $loop | awk -F"=" '{print $1}'`
	NUM=`echo $loop | awk -F"=" '{print $2}'`
		if [ $NUM -gt $DEFINE ];
			then
			grep $IP /etc/hosts.deny || echo "sshd:$IP" >> /etc/hosts.deny
		fi
done
