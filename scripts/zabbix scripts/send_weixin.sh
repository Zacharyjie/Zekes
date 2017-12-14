#!/bin/bash
#########################################################################
# Functions: send messages to wechat app
# Get ID
CropID='*******************'
# Get SecretID
Secret='********************************'
# Get token
Gettoken_URL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CropID&corpsecret=$Secret"
Access_Token=$(/usr/bin/curl -s -G $Gettoken_URL | awk -F\" '{print $4}')
Send_Message_URL="https://qyapi.weixin.qq.com/cgi-bin/chat/send?access_token=$Access_Token"
sendWeixin_body_session(){
                  local int SessionID=1						#会话的ID
                  local sender=ywbz.list@finchina.com		#消息发送者
                  local message=$(echo "$@")				#过滤出zabbix传递的第三个参数
                  printf '\n{\n'
                  printf '\t"receiver": \n'
                  printf '{\n'
                  printf '\t"type": "group",\n'
                  printf '\t"id": "'"$SessionID"\""\n"
                  printf '},\n'
                  printf '\t"sender": "'"$sender"\"",\n"
                  printf '\t"msgtype": "text",\n'
                  printf '\t"text": \n'
                  printf '{\n'
                  printf '\t\t"content": "'"$message"\""\n"
                  printf '\t},\n'
                  printf '}\n'
                         }
/usr/bin/curl --data-ascii "$(sendWeixin_body_session $3)" $Send_Message_URL
