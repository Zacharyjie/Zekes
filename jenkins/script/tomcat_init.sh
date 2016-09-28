#!/bin/bash
# $1   tomcat path 
# $2   jenkins job project_name
# $3   jenkins job bulid_id
# $4   off|on

prog="tomcat_init.sh"
basedir="/usr/local/websrv"
template_file="apache-tomcat-template"
old_tomcat="apache-tomcat-7.0.64"
tomcatname=$1
wget_host="172.16.11.18"
port_t=$(echo "$1" | awk -F'_' '{print $3}')
port_t1=$(expr $port_t + 2)
port_t2=$(expr $port_t + 3)
jdkbasedir="/usr/local/jdk1.7.0_80"
tomcat_template="apache-tomcat-template2.tar.gz"
chmod 755 $basedir/*.sh
chmod 755 $basedir/$tomcatname/*.sh
rm -rf $basedir/builds/$2/$3

############ tmp start ###########
rm -rf $basedir/$old_tomcat*
rm -rf $basedir/jdk*.tar.gz
if [ ! -d "$jdkbasedir" ]; then
    echo "[INFO] -----------------------------------------------------------------------------------------------------"
    echo "[INFO] Error: no $jdkbasedir, Please contact system administrator."
    echo "[INFO] -----------------------------------------------------------------------------------------------------"
    if [ ! -d "/opt/jdk1.7.0_80" ]; then
        cd /home/lscm
        wget -c http://$wget_host/jdk1.7.tar.gz
        tar -xvf jdk1.7.tar.gz
        jdkbasedir_tmp="/home/lscm/jdk1.7.0_80"
    fi
fi

############ judge template is exist ############
downdir() {
    cd  $basedir
    rm -rf $tomcat_template*
    wget -c http://$wget_host/$tomcat_template
    tar -xvf $tomcat_template
    rm -rf $tomcat_template*
}

checkdir() {
    if [ ! -d "$basedir/$template_file" ]; then
        echo "[INFO] ---------------------------------------------------------- Start download wget new template: $template_file.tar.gz -----------------------------------------------------------------"
        downdir
    fi
    if [ "$4" == "on" ]; then
        echo "[INFO] ---------------------------------------------------------- Start download wget new template: $template_file.tar.gz -----------------------------------------------------------------"
        rm -rf $basedir/apache-tomcat-template
        downdir
    fi
}

############ judge tomcat_xxx_xxx is exist ############
mvname() {
    if [ ! -d "$basedir/$tomcatname/bin" ]; then
        rm -rf $basedir/$tomcatname
    fi
    if [ ! -f "$basedir/$tomcatname/RUNNING.txt" ]; then
    	rm -rf $basedir/$tomcatname
    fi
    if [ -d "$basedir/$tomcatname" ]; then
        echo "[INFO] ---------------------------------------------------------- Copy configure port with $tomcatname/conf -----------------------------------------------------------------"
        /bin/cp $basedir/$template_file/conf/server.xml	$basedir/$tomcatname/conf
    else
        cp -rf $basedir/$template_file $basedir/$tomcatname
    fi
}

############ replace tomcat_xxx_xxx's port ############
change_port() {
    sed -i "s#port_t1#${port_t1}#g" $basedir/$tomcatname/conf/server.xml
    sed -i "s#port_t2#${port_t2}#g" $basedir/$tomcatname/conf/server.xml
    sed -i "s#port_t#${port_t}#g" $basedir/$tomcatname/conf/server.xml
    if [ "$jdkbasedir_tmp" != "" ]; then
        sed -i "s#${jdkbasedir}#${jdkbasedir_tmp}#g" $basedir/$tomcatname/conf/server.xml
    fi
}

############ check port num ############
LENGTH=$(echo $port_t | awk '{print length($0)}')
if [ $LENGTH -eq 4 ]; then
    port_t1=$(expr $port_t + 30000)
    port_t2=$(expr $port_t + 40000)	
    checkdir && mvname && change_port		      
elif [ $LENGTH -eq 5 ]; then
    if [ $port_t -gt 40000 ]; then
        port_t1=$(expr $port_t - 20000)
        port_t2=$(expr $port_t - 10000)
    else
        port_t1=$(expr $port_t + 10000)
        port_t2=$(expr $port_t + 20000)
    fi
    checkdir && mvname && change_port
else
    echo $"Usage: $prog {tomcatname|portnumber|download}"
    exit 1
fi
