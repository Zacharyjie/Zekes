#!/bin/bash
#install zabbix 2.4.3

#Install and config 
wget http://10.30.103.139:/soft/zabbix-2.4.3.tar.gz
tar zxvf zabbix-2.4.3.tar.gz

cd zabbix-2.4.3
./configure --prefix=/usr/local/zabbix --enable-agent &&  make &&  make install || exit 1
useradd -s /sbin/nologin zabbix


cat >> /etc/services << "EOF"
zabbix-agent 10050/tcp Zabbix Agent
zabbix-agent 10050/udp Zabbix Agent
EOF

#mkdir /etc/zabbix
#cp misc/conf/zabbix_agent.conf /etc/zabbix/
#cp misc/conf/zabbix_agentd.conf /etc/zabbix/

#zabbix conf
ln -s /usr/local/zabbix/etc/ /etc/zabbix
sed -i '13s#Server=127.0.0.1#Server=10.30.99.102#' /etc/zabbix/zabbix_agent.conf
sed -i '81s#Server=127.0.0.1#Server=10.30.99.102#' /etc/zabbix/zabbix_agentd.conf
sed -i '122s#ServerActive=127.0.0.1#ServerActive=10.30.99.102#' /etc/zabbix/zabbix_agentd.conf
sed -i '133s/^/#/' /etc/zabbix/zabbix_agentd.conf
echo "Hostname=$HOSTNAME" >> /etc/zabbix/zabbix_agentd.conf

#init shell
cp misc/init.d/fedora/core/zabbix_agentd /etc/init.d/
chmod a+x /etc/init.d/zabbix_agentd

sed -i '22s#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix#' /etc/init.d/zabbix_agentd
chkconfig --add zabbix_agentd && chkconfig zabbix_agentd on && /etc/init.d/zabbix_agentd start
