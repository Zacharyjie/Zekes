#!/bin/bash
#
# Script Name: initSystem.sh
# Description: setup linux system init.
# Author: 300second - 51cto.com
# Date: 2012-10-30
#  
#设置系统环境变量
export PATH=$PATH:/bin:/sbin:/usr/sbin
export LANG="zh_CN.GB18030"
#判断用户身份root和网络
echo "检测当前用户身份中..."
if [[ "$(whoami)" != "root" ]]; then
echo "请使用root身份执行该脚本." >&2;
exit 1;
fi
if [[ "$(whoami)" == "root" ]]; then
echo "当前用户是root,确定完毕!"
fi
sleep 1;
echo -e "\033[47;31;5m+-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*+\033[0m"
echo -e "\033[47;31;5m+                                                              +\033[0m"
echo -e "\033[47;31;5m+                         脚本说明                             +\033[0m"
echo -e "\033[47;31;5m+             这个是系统初始化脚本，请慎重运行!                +\033[0m"
echo -e "\033[47;31;5m+                                                              +\033[0m"
echo -e "\033[47;31;5m+-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*+\033[0m"
#定义命令变量
SERVICE=`which service`
CHKCONFIG=`which chkconfig`
#Source function library.
. /etc/init.d/functions
#设置系统字符编码
initI18n() {
cat << EOF
+--------------------------------------------------------------+
+------       Welcome to Set the character encoding.     ------+
+--------------------------------------------------------------+
EOF
\cp /etc/sysconfig/i18n /etc/sysconfig/i18n.`date +"%Y-%m-%d_%H-%M-%S"`.bak
sed -i 's#LANG="en_US.UTF-8"#LANG="zh_CN.GB18030"#' /etc/sysconfig/i18n
source /etc/sysconfig/i18n
echo 当前系统字符编码设置为:`grep LANG /etc/sysconfig/i18n`
echo "设置系统字符编码.------->OK"
sleep 3
}
#设置ip地址和dns
initIpAddr() {
cat << EOF
+--------------------------------------------------------------+
+------            Welcome to Set the IPADDR.            ------+
+--------------------------------------------------------------+
EOF
read -p  "请输入网卡设备名称(eth0):" CARD_TYPE
read -p  "请输入ip地址(192.168.0.2):" IPADDR
read -p  "请输入netmask地址(255.255.255.0):" NETMASK
read -p  "请输入gateway地址(192.168.0.254):" GATEWAY
read -p  "请输入dns1地址(114.114.114.114):" MYDNS1
read -p  "请输入dns2地址(8.8.8.8):"  MYDNS2
MAC=$(ifconfig $CARD_TYPE | grep "HWaddr" | awk -F[" "]+ '{print $5}')
\cp /etc/sysconfig/network-scripts/ifcfg-$CARD_TYPE  /etc/sysconfig/network-scripts/ifcfg-$CARD_TYPE.`date +"%Y-%m-%d_%H-%M-%S"`.bak
cat >/etc/sysconfig/network-scripts/ifcfg-$CARD_TYPE <<ENDF
DEVICE=$CARD_TYPE
BOOTPROTO=static
HWADDR=$MAC
NM_CONTROLLED=yes
ONBOOT=yes
TYPE=Ethernet
IPV6INIT=no
IPADDR=$IPADDR
NETMASK=$NETMASK
GATEWAY=$GATEWAY
DNS1=$MYDNS1
DNS2=$MYDNS2
ENDF
\cp /etc/resolv.conf  /etc/resolv.conf.`date +"%Y-%m-%d_%H-%M-%S"`.bak
cat >/etc/resolv.conf <<ENDF
nameserver $MYDNS1 
nameserver $MYDNS2 
ENDF
/etc/init.d/network restart
echo 当前ip地址为:`ifconfig eth0|grep "inet addr:"|awk '{print $2}'|cut -c 6-`
echo "检测当前新ip地址和dns的可用性...";
/bin/ping www.baidu.com -c 2 >> /dev/null
if [ $? != 0 ]
then
    echo "ip地址配置错误，请检查相关配置文件!";
    exit 3;
fi
echo "网络检测正常！";
echo "设置ip地址和dns.------->OK"
}
#设置主机名
initHostName(){
cat << EOF
+--------------------------------------------------------------+
+----------       Welcome to Set the HostName.    -------------+
+--------------------------------------------------------------+
EOF
\cp /etc/hosts /etc/hosts.`date +"%Y-%m-%d_%H-%M-%S"`.bak
read -p  "请输入主机名:" HostName
read -p  "请输入ip地址:" IP
echo "您输入的主机名是: $HostName"
read -p  "确定主机名是?$HostName yes or no:" isY
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ] && [ "${isY}" != "yes" ] && [ "${isY}" != "YES" ];then
exit 1
fi
echo "$IP $HostName" >> /etc/hosts
#使hostname生效
hostname $HostName
\cp /etc/sysconfig/network /etc/sysconfig/network.`date +"%Y-%m-%d_%H-%M-%S"`.bak
sed -i "/^HOSTNAME/c HOSTNAME=$HostName" /etc/sysconfig/network
echo 当前主机名设置为:`hostname`
echo "设置主机名hostname.------->OK"
sleep 3
}
#添加用户
initAddUser() {
cat << EOF
+--------------------------------------------------------------+
+--------------       Welcome to Add User.    -----------------+
+--------------------------------------------------------------+
EOF
input_fun()
{
    OUTPUT_VAR=$1
    INPUT_VAR=""
    while [ -z $INPUT_VAR ];do
        read -p "$OUTPUT_VAR" INPUT_VAR
    done
    echo $INPUT_VAR
}
user_add()
{
    local User1=(yddlogin tmp3)
    local PWD1=(ydd007#1@ qwert!@#$%) 
    local I9=0
    while [[ "$I9" < "${#User1[@]}" ]]
    do
    useradd -d /home ${User1[$I9]}
    echo "${PWD1[$I9]}" | passwd ${User1[$I9]} --stdin
    I9=`expr $I9 + 1`
    done
    echo "添加登录用户完成"
}
user_add
}
#设置ssh
initSsh() {
cat << EOF
+--------------------------------------------------------------+
+------------       Welcome to Set the Ssh.    ----------------+
+--------------------------------------------------------------+
EOF
\cp /etc/ssh/sshd_config /etc/ssh/sshd_config.`date +"%Y-%m-%d_%H-%M-%S"`.bak
cat >/etc/ssh/sshd_config<<EOF
#	$OpenBSD: sshd_config,v 1.80 2008/07/02 02:24:18 djm Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/bin:/usr/bin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options change a
# default value.

#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

# Disable legacy (protocol version 1) support in the server for new
# installations. In future the default will change to require explicit
# activation of protocol 1
Protocol 2

# HostKey for protocol version 1
#HostKey /etc/ssh/ssh_host_key
# HostKeys for protocol version 2
#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_dsa_key

# Lifetime and size of ephemeral version 1 server key
#KeyRegenerationInterval 1h
#ServerKeyBits 1024

# Logging
# obsoletes QuietMode and FascistLogging
#SyslogFacility AUTH
SyslogFacility AUTHPRIV
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
PermitRootLogin yes
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#RSAAuthentication yes
#PubkeyAuthentication yes
#AuthorizedKeysFile	.ssh/authorized_keys
#AuthorizedKeysCommand none
#AuthorizedKeysCommandRunAs nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#RhostsRSAAuthentication no
# similar for protocol version 2
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# RhostsRSAAuthentication and HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no
PasswordAuthentication yes

# Change to no to disable s/key passwords
#ChallengeResponseAuthentication yes
ChallengeResponseAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
#GSSAPIAuthentication no
GSSAPIAuthentication yes
#GSSAPICleanupCredentials yes
GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no

# Set this to 'yes' to enable PAM authentication, account processing, 
# and session processing. If this is enabled, PAM authentication will 
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
#UsePAM no
UsePAM yes

# Accept locale-related environment variables
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#UseLogin no
#UsePrivilegeSeparation yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#ShowPatchLevel no
#UseDNS yes
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem	sftp	/usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	ForceCommand cvs server
UseDNS no
allowusers root@192.168.1.180
allowusers tmp3@192.168.1.180
allowusers yddlogin@192.168.1.210
allowusers root 
EOF

\cp /etc/pam.d/sshd /etc/pam.d/sshd.`date +"%Y-%m-%d_%H-%M-%S"`.bak
cat >/etc/pam.d/sshd <<EOF
#%PAM-1.0
auth required pam_listfile.so item=user sense=allow file=/etc/sshallowusers onerr=fail
auth	   required	pam_sepermit.so
auth       include      password-auth
account    required     pam_nologin.so
account    include      password-auth
password   include      password-auth
# pam_selinux.so close should be the first session rule
session    required     pam_selinux.so close
session    required     pam_loginuid.so
# pam_selinux.so open should only be followed by sessions to be executed in the user context
session    required     pam_selinux.so open env_params
session    optional     pam_keyinit.so force revoke
session    include      password-auth
EOF

cat >/etc/sshallowusers <<EOF
tmp3
yddlogin
root
EOF
/etc/init.d/sshd restart
echo "配置ssh.------>OK"
}
#关闭不必要系统服务
initService() {
cat << EOF
+--------------------------------------------------------------+
+-------   Welcome to Close unnecessary system service.  ------+
+--------------------------------------------------------------+
EOF
export LANG="en_US.UTF-8"
local ServiceName="acpid anacron apmd atd auditd autofs avahi-daemon avahi-dnsconfd bluetooth cpuspeed cups dhcpd firstboot gpm haldaemon hidd ip6tables ipsec isdn kudzu lpd mcstrans messagebus microcode_ctl netfs nfs nfs
lock nscd pcscd portmap readahea d_early restorecond rpcgssd rpcidmapd rstatd sendmail setroubleshoot snmpd sysstat xfs xinetd yppasswdd ypserv"
#停止服务
for i in $ServiceName ;do
#echo $i
  service $i stop
done
#卸载服务
for i in $ServiceName ;do
  chkconfig $i off
done
echo "关闭不必要的系统服务.------>OK"
sleep 3
}
#禁止ctrl+alt+del三个键重启系统
initSafe() {
cat << EOF
+--------------------------------------------------------------+
+-- Welcome to Disable ctrlaltdel three key to reboot system.--+
+--------------------------------------------------------------+
EOF
\cp /etc/inittab /etc/inittab.`date +"%Y-%m-%d_%H-%M-%S"`.bak
sed -i "s/ca::ctrlaltdel:\/sbin/shutdown -t3 -r now/#ca::ctrlaltdel:\/sbin/shutdown -t3 -r now/" /etc/inittab
/sbin/init q
echo "禁止ctrl+alt+del三个键重启系统.------>OK"
sleep 3
}
#调整系统打开文件数
initOpenFiles() {
cat << EOF
+--------------------------------------------------------------+
+------    Welcome to Adjust the number of open files.   ------+
+--------------------------------------------------------------+
EOF
\cp /etc/security/limits.conf /etc/security/limits.conf.`date +"%Y-%m-%d_%H-%M-%S"`.bak
sed -i ' /# End of file/i\*\t\t-\tnofile\t\t65535' /etc/security/limits.conf
ulimit -HSn 65535
echo "ulimit -HSn 65535" >> /etc/rc.local
echo "调整系统打开文件数.------>OK"
sleep 3 
}
#设置系统同步时间
initSysTime() {
cat << EOF
+--------------------------------------------------------------+
+------    Welcome to Set system time synchronization.   ------+
+--------------------------------------------------------------+
EOF

yum -y install ntp >>/dev/null 2>&1
ntpdate asia.pool.ntp.org 
echo "*/10 * * * * /usr/sbin/ntpdate asia.pool.ntp.org >/dev/null 2>&1" >>/var/spool/cron/root
echo "设置系统同步时间.------>OK"
sleep 3
}
#安装系统工具
initTool() {
cat << EOF
+--------------------------------------------------------------+
+------       Welcome to Installation system tools.      ------+
+--------------------------------------------------------------+
EOF
yum -y install  net-tools  wget >/dev/null 2>&1
yum -y groupinstall 'Development tools' 'Chinese Support'   > /dev/null 
echo "安装系统工具.------->OK"
sleep 3
}
#禁止使用IPV6
initIPV6() {
cat << EOF
+--------------------------------------------------------------+
+------        Welcome to Prohibit the use of IPV6.      ------+
+--------------------------------------------------------------+
EOF
\cp /etc/modprobe.conf /etc/modprobe.conf.`date +"%Y-%m-%d_%H-%M-%S"`.bak
echo "alias net-pf-10 off" >> /etc/modprobe.conf
echo "alias ipv6 off" >> /etc/modprobe.conf
echo "禁止使用ipv6.------>OK"
sleep 3
}
#重要文件的保护设置
initImportFile(){
cat << EOF
+--------------------------------------------------------------+
+------        Welcome to Protect the  ImportFile.      -------+
+--------------------------------------------------------------+
EOF
local ImportFile='/etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/services'
for i in $ImportFile ;do
     chattr +i $i
done
echo "重要文件保护设置------->OK"
}
#设置登录超时时间
initLogoutTimeout(){
cat << EOF
+--------------------------------------------------------------+
+---------       Welcome to Set Logout Timeout.      ----------+
+--------------------------------------------------------------+
EOF
local Conf_File="/etc/profile"
local Key_Word="^HISTSIZE"
local Line_Num=`cat $Conf_File | awk "/$Key_Word/{print NR}"`
local Add_Line="TMOUT=300"  #300秒 5分钟
\cp $Conf_File $Conf_File.`date +"%Y-%m-%d_%H-%M-%S"`.bak
sed -i "${Line_Num}a $Add_Line" $Conf_File
source $Conf_File
echo "设置自动注销时间----->OK"
}
#安装zabbix_agent
initZabbixAgent() {
cat << EOF
+--------------------------------------------------------------+
+------       Welcome to Installation Zabbix_agent.      ------+
+--------------------------------------------------------------+
EOF
local LocalIp=$(ifconfig | grep netmask | grep -v 127.0.0.1 | awk '{print $2}')
local ZabbixDir=/usr/local/src
echo "当前目录为:$ZabbixDir"
echo "本机ip为:$LocalIp"
read -p  "请输入您的zabbix server的ip地址:" ServerIP
echo "zabbix服务器ip为:$ServerIP"
read -p  "zabbix-server-IP is $ServerIP yes or no:" isY
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ] && [ "${isY}" != "yes" ] && [ "${isY}" != "YES" ];then
exit 1
fi
echo "安装相关组件"
yum install -y  gcc gcc-c++
echo "创建zabbix用户"
groupadd zabbix
useradd -g zabbix zabbix

echo "安装zabbix-agent"
sleep 3
cd /usr/local/src
wget http://jaist.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.4.4/zabbix-2.4.4.tar.gz
tar zxvf $ZabbixDir/zabbix-2.4.4.tar.gz
cd $ZabbixDir/zabbix-2.4.4
echo `pwd`
./configure --prefix=/usr/local/zabbix/ --enable-agent
sleep 3
make
make install
echo "配置zabbix server ip为 $ServerIP"
sed -i "s/^Server=127.0.0.1/Server=$ServerIP/g" /usr/local/zabbix/etc/zabbix_agentd.conf
sed -i "s/^ServerActive=127.0.0.1/ServerActive=$ServerIP:10051/g" /usr/local/zabbix/etc/zabbix_agentd.conf
sed -i "s/^Hostname=Zabbix server/Hostname=$LocalIp/g" /usr/local/zabbix/etc/zabbix_agentd.conf
echo "创建启动init"
cp $ZabbixDir/zabbix-2.4.4/misc/init.d/tru64/zabbix_agentd /etc/init.d/
chmod +x /etc/init.d/zabbix_agentd
sed -i "s:DAEMON=/usr/local/sbin/zabbix_agentd:DAEMON=/usr/local/zabbix/sbin/zabbix_agentd:g" /etc/init.d/zabbix_agentd
echo "启动zabbix_agentd"
/etc/init.d/zabbix_agentd start
echo "/etc/init.d/zabbix_agentd start" >>/etc/rc.local
chmod 744 /etc/rc.d/rc.local
ehco "设置防火墙规则"
#sed -i  "/-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT/a \
#-A INPUT -m state --state NEW -m tcp -p tcp --dport 10050 -j ACCEPT" /etc/sysconfig/iptables
#/etc/init.d/iptables restart
echo "安装zabbix_agent客户端.------>OK"
sleep 3
}
#AStr="设置字符编码"
#BStr="设置ip地址和dns"
CStr="设置主机名"
DStr="添加用户"
EStr="设置ssh服务"
FStr="关闭不必要的服务"
GStr="禁止Ctrl+Alt+Del三个键重启系统"
HStr="调整系统打开文件数"
IStr="设置系统同步时间"
JStr="安装系统工具"
KStr="禁止使用IPV6"
LStr="设置重要文件保护"
MStr="设置登录超时时间"
NStr="安装zabbix客户端"
OStr="一键初始化"
echo "+--------------------------------------------------------------+"
echo "+-----------------欢迎对系统进行初始化安全设置！---------------+"
#echo -e "\033[35mA：${AStr}\033[0m"
#echo -e "\033[35mB：${BStr}\033[0m"
echo -e "\033[35mC：${CStr}\033[0m"
echo -e "\033[35mD：${DStr}\033[0m"
echo -e "\033[35mE：${EStr}\033[0m"
echo -e "\033[35mF：${FStr}\033[0m"
echo -e "\033[35mG：${GStr}\033[0m"
echo -e "\033[35mH：${HStr}\033[0m"
echo -e "\033[35mI：${IStr}\033[0m"
echo -e "\033[35mJ：${JStr}\033[0m"
echo -e "\033[35mK：${KStr}\033[0m"
echo -e "\033[35mL：${LStr}\033[0m"
echo -e "\033[35mM：${MStr}\033[0m"
echo -e "\033[35mN：${NStr}\033[0m"
echo -e "\033[35mO：${OStr}\033[0m"
echo "+--------------------------------------------------------------+"
echo -e "\033[31m注意：如果没有选择初始化选项，20秒后将自动选择一键初始化安装！\033[0m"
echo "+--------------------------------------------------------------+"
option="-1"
read -n1 -t20 -p "请选择初始化选项【A-B-C-D-E-F-G-H-I-J-K-L-M-N-O】:" option
flag1=$(echo $option|egrep "\-1"|wc -l)
flag2=$(echo $option|egrep "[A-Ra-r]"|wc -l)
if [ $flag1 -eq 1 ];then
   option="S"
elif [ $flag2 -ne 1 ];then
   echo -e "\n\n请重新运行脚本，输入从A--->Q的字母！"
   exit 1
fi
echo -e "\n你选择的选项是：$option\n"
echo "2秒之后开始安装 ......"
sleep 2
case $option in
   C|c)
         initHostName
      ;;
   D|d)
         initAddUser
      ;;
   E|e)
         initSsh
      ;;
   F|f)
         initService
      ;;
   G|g)
         initSafe
      ;;
   H|h)
         initOpenFiles
      ;;
   I|i)
         initSysTime
      ;;
   J|j)
         initTool
      ;;
   K|k)
         initIPV6
      ;;
   L|l)
         initImportFile
      ;;
   M|m)
         initLogoutTimeout
      ;;
   N|n)
         initZabbixAgent
      ;;
   O|o) 
         initHostName
         initTool
         initZabbixAgent
         initAddUser
         initSsh
         initService
         initSafe
         initOpenFiles
         initSysTime
         initIPV6
         initImportFile
         initLogoutTimeout
       ;;
     *)
         echo "请输入从C--->R的字母，谢谢!"
         exit
      ;;
esac
