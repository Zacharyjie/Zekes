#/bin/bash

set -e

set -o pipefail

en_container()
{
    C_PID=`docker inspect --format "{{ .State.Pid }}" $1`
    nsenter --target  $C_PID --mount --uts --ipc --net --pid
}

NUM=`docker ps -a|awk 'NR>1 && / Up/'|wc -l`

if [[ -z $1 ]];then
    if [[ $NUM -eq 0 ]];then
        while :
        do
          if read -n 30 -p "there no container up,are you want up a container(yes/no):" EN
          then 
              case $EN in 
                         yes|y|Y|YES)
                                     echo "ok,let's go"
                                     docker ps -a
                                     read -p "which container you need up:" C_PID
                                     docker start $C_PID
                                     en_container $C_PID
                                     break
                                     ;;
                         no|n|N|NO)
                                  echo "bye bye!"
                                  break
                                  ;;
                         *)
                           echo "you should input yes or no!"
                           continue
              esac
         else
         echo "Unknown ERROR EXIT"
         break
         fi
       done
    elif [[ $NUM -eq 1 ]];then
        LC_PID=docker ps -a|awk 'NR>1 && / Up/'
        while :
        do
            if read  -n 30 -p  "you want enter the above container(yes/no):" EN
            then 
                case $EN in
                            NO|N|n|no)
                                       echo "ok,go back"
                                       docker ps -a
                                       read -p "which container you need up:" C_PID
                                       docker start $C_PID
                                       en_container $C_PID
                                       break
                                       ;;
                          yes|y|Y|YES)
                                      echo "ok,let's go"
                                      en_container $LC_PID
                                      break
                                      ;;
                          *)
                            echo "you should input yes or no!"
                            continue
                esac
           else
           echo "Unknown ERROR EXIT"
           break
           fi
        done
    elif [[ $NUM -gt 1 ]];then
        docker ps -a
        if read -t 30 -p "which contain you wnat enter:" C_PID
        then
            STAT=`docker ps -a|awk 'NR>1 && /'$C_PID'/ && / Up/'|wc -l`
            if [[ $STAT -eq 1 ]];then    
                en_container $C_PID 
            else 
                docker start $C_PID
                en_container $C_PID
            fi
        else
            echo "input error,exit!!"
            exit 1
        fi
    fi
else
    en_container $1
fi

    
    
        



  
