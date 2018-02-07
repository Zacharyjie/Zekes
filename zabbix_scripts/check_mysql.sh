#!/bin/bash

MYSQL_USER='zabbix'
MYSQL_PWD='ALQrGZKWdhjwOJIl'
MYSQL_PORT='3306'
MYSQL_CONN="/usr/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -P${MYSQL_PORT}"
MYSQL_CONND="/usr/bin/mysql -u${MYSQL_USER} -p${MYSQL_PWD} -P${MYSQL_PORT}"

case $1 in
    ping)
        result=`${MYSQL_CONN} ping 2> /dev/null | grep -c alive`
        echo $result 
        ;;
    uptime)
        result=`${MYSQL_CONN} status | cut -f2 -d":" | cut -f1 -d"T"`
        echo $result
        ;;
    questions)
        result=`${MYSQL_CONN} status | cut -f4 -d":" | cut -f1 -d"S"`
        echo $result
        ;;
    slowqueries)
        result=`${MYSQL_CONN} status | cut -f5 -d":" | cut -f1 -d"O"`
        echo $result
        ;;
    qps)
        result=`${MYSQL_CONN} status | cut -f9 -d":"`
        echo $result
        ;;
    abortedclients)
        result=`${MYSQL_CONND} -e 'show status' |  grep "Aborted_clients" | awk '{print $2}'`
        echo $result
        ;;
    abortedconnects)
        result=`${MYSQL_CONND} -e 'show status' | grep "Aborted_connects" | awk '{print $2}'`
        echo $result
        ;;
    openedfiles)
        result=`${MYSQL_CONND} -e 'show status' | grep 'Opened_files' | awk '{print $2}'`
        echo $result
        ;;
    qcachetotalblocks)
        result=`${MYSQL_CONND} -e 'show status' | grep 'Qcache_total_blocks' | awk '{print $2}'`
        echo $result
        ;;
    qcachefreeblocks)
        result=`${MYSQL_CONND} -e 'show status' | grep 'Qcache_free_blocks' | awk '{print $2}'`
        echo $result
        ;;
    maxusedconnections)
        result=`${MYSQL_CONND} -e 'show status' | grep 'Max_used_connections' | awk '{print $2}'`
        echo $result
        ;;
    openedtables)
        result=`${MYSQL_CONND} -e 'show status' | grep 'Open_tables' | awk '{print $2}'`
        echo $result
        ;;
    threadsconnected)
        result=`${MYSQL_CONND} -e 'show status' | grep 'Threads_connected' | awk '{print $2}'`
        echo $result
        ;;
    threadsrunning)
        result=`${MYSQL_CONND} -e 'show status' | grep 'Threads_running' | awk '{print $2}'`
        echo $result
        ;;
    selectfulljoin)
        result=`${MYSQL_CONND} -e 'show status' | grep 'Select_full_join' | awk '{print $2}'`
        echo $result
        ;;
    handlerreadrndnext)
        result=`${MYSQL_CONND} -e 'show status' | grep 'Handler_read_rnd_next' | awk '{print $2}'`
        echo $result
        ;;
    handlerreadkey)
        result=`${MYSQL_CONND} -e 'show status' | grep 'Handler_read_key' | awk '{print $2}'`
        echo $result
        ;;
    handlerreadfirst)
        result=`${MYSQL_CONND} -e 'show status' | grep 'Handler_read_first' | awk '{print $2}'`
        echo $result
        ;;
    slave)
        result=`${MYSQL_CONND} -e "show slave status\G"|egrep "Slave_IO_Running|Slave_SQL_Running"|awk '{print $2}'|wc -l`
        echo $result
        ;;
    slavedelay)
        result=`${MYSQL_CONND} -e 'SHOW SLAVE STATUS\G' | grep -w "Seconds_Behind_Master" | cut -d":" -f2`
        echo $result
        ;;
     *)
        echo "Usage:$0(
	ping|uptime|questions|slowqueries|qps||bortedclients|abortedconnects|openedfiles
        qcachetotalblocks|qcachefreeblocks|maxusedconnections|openedtables|threadsconnected|threadsrunning
        selectfulljoin|handlerreadrndnext|handlerreadkey|handlerreadfirst|slave|slavedelay)" 
        ;;
esac
