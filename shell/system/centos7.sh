#! /bin/sh

#set DNS
#echo "nameserver 202.96.209.133" >> /etc/resolv.conf
#echo "nameserver 114.114.114.114" >> /etc/resolv.conf

#安装docker源
cat >/etc/yum.repos.d/docker.repo << EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

#set ntp
yum install vim wget ntp ntpdate ntp-doc git openssh-server net-tools lrzsz -y
echo "*/2 * * * * /usr/sbin/ntpdate cn.pool.ntp.org > /dev/null 2>&1" > /var/spool/cron/root
service crond restart

#shutdown iptables
#/etc/init.d/iptables stop
#chkconfig iptables off && echo "chkconfig iptables off"
#chkconfig ip6tables off && echo "chkconfig ip6tables off"

#shutdown selinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

#shutdown ipv6
echo -e "alias net-pf-10 off\noptions ipv6 disable=1" > /etc/modprobe.d/dist-ipv6.conf

#/etc/init.d/postfix stop
#chkconfig postfix off

#set ulimit
if ! grep "65535" /etc/rc.local;then
echo "ulimit -SHn 65536" >> /etc/rc.local
fi

if ! grep "65535" /etc/security/limits.conf;then
echo "* - nofile 65535 " >> /etc/security/limits.conf
echo "* - nproc 65535 " >> /etc/security/limits.conf
fi

#set other user max processes  
sed -i 's/1024/65536/' /etc/security/limits.d/90-nproc.conf
ulimit -u 65536

#set sysctl
true > /etc/sysctl.conf
cat >> /etc/sysctl.conf << EOF
 net.ipv4.ip_forward = 0
 net.ipv4.conf.default.rp_filter = 1
 net.ipv4.conf.default.accept_source_route = 0
 kernel.sysrq = 0
 kernel.core_uses_pid = 1
 net.ipv4.tcp_syncookies = 1
 kernel.msgmnb = 65536
 kernel.msgmax = 65536
 kernel.shmmax = 68719476736
 kernel.shmall = 4294967296
 fs.file-max = 6553560
 net.ipv4.tcp_max_tw_buckets = 6000
 net.ipv4.tcp_sack = 1
 net.ipv4.tcp_window_scaling = 1
 net.ipv4.tcp_rmem = 4096 87380 4194304
 net.ipv4.tcp_wmem = 4096 16384 4194304
 net.core.wmem_default = 8388608
 net.core.rmem_default = 8388608
 net.core.rmem_max = 16777216
 net.core.wmem_max = 16777216
 net.core.netdev_max_backlog = 262144
 net.core.somaxconn = 262144
 net.ipv4.tcp_max_orphans = 3276800
 net.ipv4.tcp_max_syn_backlog = 262144
 net.ipv4.tcp_timestamps = 0
 net.ipv4.tcp_synack_retries = 1
 net.ipv4.tcp_syn_retries = 1
 net.ipv4.tcp_tw_recycle = 1
 net.ipv4.tcp_tw_reuse = 1
 net.ipv4.tcp_mem = 94500000 915000000 927000000
 net.ipv4.tcp_fin_timeout = 1
 net.ipv4.tcp_keepalive_time = 1200
 net.ipv4.ip_local_port_range = 1024 65535
 vm.swappiness = 0
EOF
/sbin/sysctl -p
[ $? = 0 ] && echo "sysctl set OK!!"

#set_user() {
#add user
#id ops
#if [ $? != 0 ];then
#useradd ops
#echo g+*=xzl+x3?kN0ps|passwd --stdin ops
#fi

#set ssh
#sed -i 's%#PermitRootLogin yes%PermitRootLogin no%' /etc/ssh/sshd_config #禁止root远程登录
sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config #ssh登录加速
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config

#用户ops sudo权限
#if ! grep ops /etc/sudoers;then
#echo "ops ALL=(root) NOPASSWD: ALL" >> /etc/sudoers.d/ops
#fi

#set timezone
echo "y" | cp -a /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#touch /var/log/user_log.log && chmod a+w /var/log/user_log.log
#echo "alias grep='grep --color=auto'" > /etc/profile.d/colorgrep.sh
#echo "export PROMPT_COMMAND='{ date \"+%Y-%m-%d %T ##### [user=\$(whoami)] \$(who am i |awk \"{print \\\$2\\\" \\\"\\\$5}\") #### [\`pwd\`]:\$(history 1 | { read x cmd; echo \"\$cmd\"; })\"; } >> /var/log/user_log.log'" > /etc/profile.d/log_user.sh

#切割用户操作日志
#cat > /etc/logrotate.d/user_log << EOF
#/var/log/user_log.log {
#weekly
#rotate 4
#size 100m
#}
#EOF
#[ $? = 0 ] && echo "/etc/logrotate.d/user_log is ok"

#重置环境变量
source /etc/profile
