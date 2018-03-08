#!/usr/bin/python
#_*_coding:utf-8 _*_

import urllib,urllib2
import json
import sys
#import simplejson

reload(sys)
sys.setdefaultencoding('utf-8')

def gettoken(corpid,corpsecret):
    gettoken_url = 'https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=' + corpid + '&corpsecret=' + corpsecret
    try:
        token_file = urllib2.urlopen(gettoken_url)
    except urllib2.HTTPError as e:
        print e.code
        print e.read().decode("utf8")
        sys.exit()
    token_data = token_file.read().decode('utf-8')
    token_json = json.loads(token_data)
    token_json.keys()
    token = token_json['access_token']
    return token

def senddata(access_token,user,content):

    send_url = 'https://qyapi.weixin.qq.com/cgi-bin/chat/send?access_token=' + access_token
    send_values = {
         "receiver":
         {
           "type": "group",                     #微信组                           
           "id": "3"
         },
         "sender": "ywbz.list@finchina.com",
         "msgtype": "text",
         "text":
        {
          "content": content
        }
      }
    send_data = json.dumps(send_values, ensure_ascii=False)
    send_request = urllib2.Request(send_url, send_data)
    response = json.loads(urllib2.urlopen(send_request).read())
    print str(response)

if __name__ == '__main__':
    user = str(sys.argv[1])     #zabbix传过来的第一个参数
    subject = str(sys.argv[2])  #zabbix传过来的第二个参数
    content = str(sys.argv[3])  #zabbix传过来的第三个参数
    corpid =  '1'   #CorpID是企业号的标识
    corpsecret = '2'  #corpsecretSecret是管理组凭证密钥
    accesstoken = gettoken(corpid,corpsecret)
    senddata(accesstoken,user,content)
