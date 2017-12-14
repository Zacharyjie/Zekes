#!/usr/bin/python
# coding:utf-8
# Must to be applied on python2.x!!!
import smtplib
from email.mime.text import MIMEText
import sys

# Need to be opened the SMTP service!!!
#mail_to_list = 'test@qq.com'
mail_host = 'smtp.263.net'
mail_user = '*****'
mail_pass = '*****'
mail_postfix = '263.net'
mail_use = 'zabbix'
def send_mail(to_list, subject, content):
    me = "Zabbix 监控告警平台"+"<"+mail_use+"@"+mail_postfix+">"
    msg = MIMEText(content, 'plain', 'utf-8')
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
#[1] 邮箱
#[2] 主题
#[3] 内容
