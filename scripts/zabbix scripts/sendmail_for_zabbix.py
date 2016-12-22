#!/usr/bin/env python2.7
# coding:utf-8
# Must to be applied on python2.x!!!
import smtplib
from email.mime.text import MIMEText
import sys

# Need to be opened the SMTP service!!!
#mail_to_list = 'test@qq.com'
mail_host = 'smtp.exmail.qq.com'
mail_user = 'test@qq.com'
mail_pass = 'yourpassword'
me = 'test@qq.com'


def send_mail(to_list, subject, content):
    msg = MIMEText(content)
    msg['Subject'] = subject
    msg['From'] = me
    msg['to'] = to_list

    try:
        s = smtplib.SMTP()
        s.connect(mail_host)
        s.login(mail_user, mail_pass)
        s.sendmail(me, to_list, msg.as_string())
        s.close()
        return True
    except Exception, e:
        print str(e), 'exception'
        return False

if __name__ == "__main__":
	send_mail(sys.argv[1], sys.argv[2], sys.argv[3])
    #send_mail(mail_to_list, sys.argv[1], sys.argv[2])
