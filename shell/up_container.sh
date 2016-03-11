#/bin/bash
#脚本功能是进入容器或者启动容器

set -e
set -o pipefail

en_container()
{
    C_PID=`docker inspect --format "{{ .State.Pid }}" $1`
    nsenter --target $C_PID --mount --uts --ipc --net --pid
}


if [[ -z $1 ]];then
    echo "################-------------------------------#################"
    docker ps -a
    echo "################-------------------------------#################"
    if read -t 60 -p "Please input container id:" C_ID
    then
        NUM=`docker ps -a|awk 'NR>1 && /^'$C_ID'/'|wc -l`
        if [[ $NUM -eq  1 ]];then
            U_NUM=`docker ps -a|awk 'NR>1 && /^'$C_ID'/ && / Up/'|wc -l`
            if [[ $U_NUM -eq 1 ]];then
                en_container $C_ID
            else
                echo "1 means only Up container"
                echo "2 means ENTER container"
                read -t 60 -p "Input 1 or 2:" EN
                if [[ $EN -eq 1 ]];then
                    docker start $C_ID
                    exit 0
                elif [[ $EN -eq 2 ]];then
                    docker start $C_ID
                    en_container $C_ID
                else
                    echo "Input Error"
                    exit 1
                fi
            fi
        else
            echo "ERROR:not a correct format for container id"
            exit 1
        fi
    else
        echo "ERROR INPUT"
        exit 1
    fi
else 
    en_container $C_ID
fi
