#!/usr/bin/python
#coding:utf-8
#适用于python2.X！！！
import smtplib
from email.mime.text import MIMEText
import sys
#mail_to_list = ['lihuipeng@xxx.com',]
mail_host = 'smtp.exmail.qq.com'
mail_user = 'qinming@gshopper.com'
mail_pass = 'Zx19931120'
me = 'qinming@gshopper.com'
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
        print str(e),'exception'
        return False
                                                                                             
if __name__ == "__main__":
    send_mail(sys.argv[1], sys.argv[2], sys.argv[3])
