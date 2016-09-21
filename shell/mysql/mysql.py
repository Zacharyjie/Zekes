#!/usr/local/python3/bin/python3.5
import pymysql.cursors

db = pymysql.connect(	
			host='172.16.100.100',
                	user='root',
			password='123456',
                	db='mysql',
					)
#	cursor.execute("show variables like '%max_connections%';")
cursor = db.cursor()
cursor.execute("show variables like '%max_connections%';")
Max = cursor.fetchone()
#cursor.execute("show global status like 'Max_used_connections';")
#History_max = cursor.fetchone()

#cursor.execute("show global status like 'Threads_connected';")
cursor.execute("show global status like 'Threads_connected';")
Currently = cursor.fetchone()

cursor.execute("show slave status;")
Slave = cursor.fetchall()

print("mysql最大连接数 ：    ",Max[1])
print("mysql当前最大连接数 ：",Currently[1])
#print("111",Slave[1])


cursor.close()
db.close()
