#!/bin/bash
# $1 ProjectName | $2 TomcatName| $3 BUILD_ID | $4 BasePath

if [ "$4" = "" ]; then
    ProjectPath="/usr/local/websrv/builds"
    TomcatPath="/usr/local/websrv/$2"
else
    ProjectPath="$4/builds"
    TomcatPath="$4/$2"
fi
LogFile="upgrade.log"
TomLog="tomcat.log"

if [ "$3" = "-1" ]; then
    echo "go back to last successful edition"
    ln -snf $ProjectPath/$1/lastsuccessful/$1 $TomcatPath/webapps/ROOT
else
    chmod 770 -R $ProjectPath/$1/$3/$1/*	
    # not exits  out
    [ -d $ProjectPath/$1/$3 ] || exit 1
    
    #set softlink
    if [ -L $ProjectPath/$1/successful ]; then
        LAST=$(tail -1 $ProjectPath/$1/$LogFile)
        rm $ProjectPath/$1/lastsuccessful && ln -s $ProjectPath/$1/$LAST $ProjectPath/$1/lastsuccessful
        rm $ProjectPath/$1/successful && ln -s $ProjectPath/$1/$3 $ProjectPath/$1/successful
    else
        ln -s $ProjectPath/$1/$3 $ProjectPath/$1/successful
        ln -s $ProjectPath/$1/$3 $ProjectPath/$1/lastsuccessful
    fi

    echo $3 >> $ProjectPath/$1/$LogFile

    [ -d $TomcatPath/webapps/ROOT ] && rm -rf $TomcatPath/webapps/ROOT
    
    if [ -d $TomcatPath ]; then
        [ -L $TomcatPath/webapps/ROOT ] || ln -s $ProjectPath/$1/successful/$1 $TomcatPath/webapps/ROOT
    else
        echo "ERROR" $1 $(date) >> $ProjectPath/$1/$TomLog && exit 1
    fi
fi
