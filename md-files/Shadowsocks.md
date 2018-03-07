## Shadowsocks in centos7
```
yum install epel-release -y
yum install gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto udns-devel libev-devel libsodium-devel mbedtls-devel -y
vim /etc/yum.repos.d/shadowsocks-lib.repo

[librehat-shadowsocks]
name=Copr repo for shadowsocks owned by librehat
baseurl=https://copr-be.cloud.fedoraproject.org/results/librehat/shadowsocks/epel-7-$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://copr-be.cloud.fedoraproject.org/results/librehat/shadowsocks/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1
```
### 配置文件
```
vim /etc/shadowsocks-libev/config.json

{
    "server":"0.0.0.0",
    "server_port":"9100",
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"passord",
    "timeout":600,
    "fast_open":false,
    "method":"aes-256-cfb"
}
```
服务配置 | 作用 |
--- | --- |
server | 服务端监听地址(IPv4或IPv6) |
server_port | 服务端端口，此处为9100 |
local_address | 本地监听地址，缺省为127.0.0.1 可用-b参数设置 |
local_port | 本地监听默认端口1080 |
password | 设置加密的密码 |
timeout | 超时时间（秒）|
fast_open | 是否启用[TCP-Fast-Open](https://github.com/shadowsocks/shadowsocks/wiki/TCP-Fast-Open) Linux内核版本需大于3.7 |
method | 加密方法 默认的table是一种不安全的加密 此处为aes-256-cfb |
system | system后台文件配置[ss-local.service](ss-local.service)|

* shadowsocks-libev此方法需配置多端口模式需多写份配置文件,推荐使用supervisor后台启动.

### 防火墙配置策略
```
yum install firewalld
systemctl start firewalld
firewall-cmd --permanent --zone=public --add-port=9100/tcp
firewall-cmd --permanent --zone=public --add-port=9100/udp
firewall-cmd --permanent --zone=public --add-port=9101/tcp
firewall-cmd --permanent --zone=public --add-port=9102/udp
firewall-cmd --reload
```
### BBR TCP加速
```
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
sudo yum --enablerepo=elrepo-kernel install kernel-ml -y
rpm -qa | grep kernel

kernel-ml-4.9.0-1.el7.elrepo.x86_64
kernel-3.10.0-514.el7.x86_64
kernel-tools-libs-3.10.0-514.2.2.el7.x86_64
kernel-tools-3.10.0-514.2.2.el7.x86_64
kernel-3.10.0-514.2.2.el7.x86_64

sudo egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
sudo grub2-set-default 0
uname -r

echo 'net.core.default_qdisc=fq' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control=bbr' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

sudo sysctl net.ipv4.tcp_available_congestion_control
net.ipv4.tcp_available_congestion_control = bbr cubic reno
sudo sysctl -n net.ipv4.tcp_congestion_control
bbr
lsmod | grep bbr
tcp_bbr                16384  0

```
