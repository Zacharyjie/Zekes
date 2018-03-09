#!/bin/bash
#安装MHA中清理Relay log报错
user=root
passwd=0ps.iz3n3s0ft
port=3306
log_dir='/data/masterha/log'
work_dir='/data'
purge='/usr/local/bin/purge_relay_logs'

if [ ! -d $log_dir ]
then
   mkdir $log_dir -p
fi

$purge --user=$user --password=$passwd --disable_relay_log_purge --port=$port --workdir=$work_dir >> $log_dir/purge_relay_logs.log 2>&1
