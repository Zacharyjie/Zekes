#!/usr/bin/env python
#coding:utf-8
import os
import smtplib
import sys
import filecmp
import time
import socket
import base64
import codecs
import os.path
from email.mime.text import MIMEText

hostname = socket.gethostname()  
ip = socket.gethostbyname(hostname)

mail_host = 'smtp.b5m.com'
mail_user = 'cacti'
mail_pass = '0ps.iz3n3'
mail_postfix = 'b5m.com'
me = 'cacti@b5m.com'

send_to_it = 'it@b5m.com'
send_to_dev = 'slowlog@b5m.com'

date = time.strftime(r"%Y-%m-%d_%H-%M-%S",time.localtime())
print "folder is %s" % date

if os.path.isdir('/data/mysql/logbak'):
        pass
else:
        os.path.mkdir('/data/mysql/logbak')

os.chdir('/data/mysql/logbak')
bakfile = open('slow'+str(date)+'.log', 'w') 
bakfile.close()
os.system('cat /data/mysql/slow.log>/data/mysql/logbak/slow%s.log' % date)
os.system('cat /dev/null>/data/mysql/slow.log')
os.system('mysqldumpslow -s c  /data/mysql/logbak/slow%s.log>/tmp/testslow.txt' % date)
#os.system('mysqldumpslow -s c -t 20 /data/mysql/logbak/slow%s.log>/tmp/testslow.txt' % date)
filename = "/tmp/testslow.txt"
fo = codecs.open(filename, "rb")
content = fo.read()



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


#send_mail(send_to_it,"%s The slow query log in the top 20 a week statistics!!"%ip,content)
send_mail(send_to_it,"%s The slow query log statistics in a week!!"%ip,content)
