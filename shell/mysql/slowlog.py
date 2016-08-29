#!/usr/bin/env python
#coding:utf-8
import os
import smtplib
import sys
import filecmp
import time
import codecs

from email.mime.text import MIMEText
mail_host = 'smtp.b5m.com'
mail_user = 'cacti'
mail_pass = '0ps.iz3n3'
mail_postfix = 'b5m.com'
me = 'cacti@b5m.com'
send_to_it = 'it@b5m.com'
send_to_dev = 'slowlog@b5m.com'

def host_name():
    os.chdir('/data/mysql')
    host=[]
    try:
	lst=os.popen("grep '# User@Host:' new.txt | cut -d ' ' -f 3").read().strip().split('\n')
        a=set(lst)
        for i in a:
            host.append(i)
        return str(host)
    except Exception,e:
        return 'Host not find'

def compare_files():
    os.chdir('/data/mysql')
    return filecmp.cmp('check.log','slow.log')

def send_mail(to_list,subject,content):
    msg = MIMEText(content)
    msg['Subject'] = subject
    msg['From'] = me
    msg['to'] = to_list
                                                                                             
    try:
        s = smtplib.SMTP()
        s.connect(mail_host)
        s.login(mail_user,mail_pass)
        s.sendmail(me,to_list,msg.as_string())
        s.close()
        return True
    except Exception,e:
        print str(e)
        return False

def check_slowlog():
    os.chdir('/data/mysql')
    os.system('git diff check.log slow.log>diff.txt')
    os.system('cp slow.log check.log')
    os.system("grep '+' diff.txt | sed 1,2d >new.txt && sed -i 's/^+//' new.txt")
#    return open('new.txt').read()
    f = codecs.open('new.txt',encoding='UTF-8')
    u = f.read()
    f.close()
    return u


if __name__=='__main__':
    while True:
	if compare_files() is not True:
	    content = check_slowlog()
	    host = host_name()
    	    send_mail(send_to_dev,'%s slow query alert!!'%host,content)
    	    send_mail(send_to_it,'10.30.105.27 slow query alert!!',content)
	time.sleep(300)
