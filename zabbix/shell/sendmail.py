#!/usr/bin/env python
#coding:utf-8
import smtplib
from email.mime.text import MIMEText
import sys
#mail_to_list = ['lihuipeng@xxx.com',]
mail_host = 'smtp.exmail.qq.com'
mail_user = 'zabbix@qq.com'
mail_pass = '123456'
mail_postfix = 'qq.com'
me = 'zabbix@qq.com'
def send_mail(to_list,subject,content):
    #me = mail_user+"<"+mail_user+"@"+mail_postfix+">"
    msg = MIMEText(content)
    msg['Subject'] = subject
    msg['From'] = me
    msg['to'] = to_list
                                                                                             
    try:
        s = smtplib.SMTP()
	print '1 ok'
        s.connect(mail_host)
	print '2 ok'
        s.login(mail_user,mail_pass)
	print '3 ok'
        s.sendmail(me,to_list,msg.as_string())
	print '4 ok'
        s.close()
        return True
    except Exception,e:
        print str(e),'exception'
        return False
                                                                                             
if __name__ == "__main__":
    #print sys.argv[1]
    #print sys.argv[2]
    #print sys.argv[3]
    send_mail(sys.argv[1], sys.argv[2], sys.argv[3])
