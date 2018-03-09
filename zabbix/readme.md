
## Zabbix相关介绍
### 3.2版本源
```
rpm -ivh http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm

```
```
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by '123456';
flush privileges;
zcat /usr/share/doc/zabbix-server-mysql-3.2.*/create.sql.gz | mysql -uzabbix -hhost -Ddatabase -P3306     -p123456
```
### 源码安装
```
./configure --prefix=/usr/local/zabbix --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2 --with-openipmi --with-ldap --with-ssh2 --with-openssl

yum install gcc gcc-c++ libxml2-devel net-snmp-devel libssh2-devel OpenIPMI-devel libevent-devel curl-devel libjpeg-devel libpng-devel  freetype-devel mariadb mariadb-devel
```
### Nginx+php整合
```
./configure --prefix=/usr/local/php7 --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-gettext --with-mysqli --with-openssl --with-pcre-regex --with-pdo-mysql --with-pdo-sqlite --with-pear --with-zlib --enable-bcmath -enable-fpm --enable-libxml --enable-mbregex --enable-mbstring --enable-opcache --enable-sockets --enable-xml --enable-zip --enable-mysqlnd
```
### 动作脚本参数
```
{ALERT.SENDTO}
{ALERT.SUBJECT}
{ALERT.MESSAGE}

服务器:{HOST.NAME}发生: {TRIGGER.NAME}故障!
{
告警主机:{HOST.NAME}
告警地址:{HOST.IP}
监控项目:{ITEM.NAME}
主要用途:{HOST.DESCRIPTION}
监控取值:{ITEM.LASTVALUE}
告警等级:{TRIGGER.SEVERITY}
当前状态:{TRIGGER.STATUS}
告警信息:{TRIGGER.NAME}
告警时间:{EVENT.DATE} {EVENT.TIME}
事件ID:{EVENT.ID}
}


服务器:{HOST.NAME}: {TRIGGER.NAME}已恢复!
{
告警主机:{HOST.NAME}
告警地址:{HOST.IP}
监控项目:{ITEM.NAME}
监控取值:{ITEM.LASTVALUE}
告警等级:{TRIGGER.SEVERITY}
当前状态:{TRIGGER.STATUS}
告警信息:{TRIGGER.NAME}
告警时间:{EVENT.DATE} {EVENT.TIME}
恢复时间:{EVENT.RECOVERY.DATE} {EVENT.RECOVERY.TIME}
持续时间:{EVENT.AGE}
事件ID:{EVENT.ID}
}


服务器:{HOST.NAME}: 报警确认
{
确认人:{USER.FULLNAME}
时间:{ACK.DATE} {ACK.TIME}
确认信息如下:
"{ACK.MESSAGE}"
问题服务器IP:{HOSTNAME1}
问题ID:{EVENT.ID}
当前的问题是: {TRIGGER.NAME}
}
```
### Zabbix 告警优化
* 触发器name支持获取变量 例如{ITEM.VALUE} {HOST.NAME}
* 微信告警脚本字符问题,例如[sendWeixin.py](sendWeixin.py)
#### 配置相关调优

http://blog.csdn.net/jiangshan35/article/details/52314079

#### 遇到的问题
1. Zabbix Server 自动停止
```
源码安装后  zabbix_agentd.conf修改增加字段
/usr/local/zabbix/etc/zabbix_agentd.conf.d/
```
