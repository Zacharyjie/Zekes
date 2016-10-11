#!/bin/bash
# Install kvm for centos6.X!!!
set -e
set -o pipefail
#运行需要root用户
[ $(id -u) != "0" ] && { echo -e "\033[31mError: You must be root to run this script\033[0m"; exit 1; } 
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
clear

yum -y install qemu-kvm libvirt python-virtinst bridge-utils
yum update -y device-mapper

#[ `lsmod | grep -c kvm` != "2" ] && { echo -e "\033[31mError: KVM Model not be install!!\033[0m"; exit 1; } 
#更改网卡环境变量
ETH=`route | grep default | awk '{print $NF}'`
ETHD="br`route | grep default | awk '{print $NF}'| sed -r 's/[^0-9.]+//g'`"
DATE="/etc/sysconfig/network-scripts"
IPADDR=`grep -E "IPADDR|NETMASK|GATEWAY|DNS1|DNS2" $DATE/ifcfg-$ETH`
IPADDRD=`egrep -v "IPADDR|NETMASK|GATEWAY|DNS1|DNS2" $DATE/ifcfg-$ETH`
#备份原网卡
cp $DATE/ifcfg-$ETH $DATE/ifcfg-$ETH.bak
cp $DATE/ifcfg-$ETH $DATE/ifcfg-$ETHD
#更改br网桥配置
cat > $DATE/ifcfg-$ETHD << EOF
DEVICE=$ETHD
TYPE=Bridge
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
$IPADDR
DELAY=0
NAME="System $ETHD"
EOF
#更改原网卡配置
cat > $DATE/ifcfg-$ETH << EOF
$IPADDRD
BRIDGE=$ETHD
EOF

/etc/init.d/network restart
clear

echo "Done"
