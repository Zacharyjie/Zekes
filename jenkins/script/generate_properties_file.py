#!/usr/bin/env python

import os
import sys
import time
path=os.getcwd()+'/'+sys.argv[2]

backpath='/usr/local/websrv/jenkins/resources/all/'+ sys.argv[1] +'/bak'
f_lst=[]
os.chdir('/usr/local/websrv/jenkins/resources/all/' + sys.argv[1])
fname='config.all.properties'

newfname=backpath+'/'+fname+'_'+time.strftime('%Y-%m-%d_%H:%M')
if os.path.isfile('config.all.properties'):
   os.system('cp %s %s'%(fname,newfname))
   print '\033[34;1m History file conf.all.properties has copyed to \033[0m'+'\033[31;1m %s\033[0m'%newfname

f=open(fname,'w')
f.close()

for items in os.listdir(path):
    if os.path.isfile(path+'/'+items) and items.split('.')[-1]=='properties' and items.split('.')[0]=='config':
	f_lst.append(items)

f_lst.sort()

for file in f_lst:
    os.system('cat %s >> %s '%(path+'/'+file,fname))
    os.system('echo '' >> %s'%fname)
    os.system('echo '' >> %s'%fname)

print '\033[34;1mA new file\033[0m'+'\033[31;1m conf.all.properties\033[0m'+'\033[34;1m has been generated,please enjoy!\033[0m'
