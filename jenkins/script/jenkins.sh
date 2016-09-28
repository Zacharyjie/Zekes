#!/bin/bash
# @mike @yegucheng
#jenkins all shell 

#	$1	bashpath 默认的总目录			fx: /usr/local/websrv
#	$2	JOB_NAME jenkins工作名称		fx: tomcat-prod-pay
#	$3	BUILD_ID 当前执行的编号			fx: 55
#	$4	project_name 项目名字key		fx: activity | pay
#	$5	project_tomcatname 项目的tomcat路径	fx: tomcat_pay_5251 | tomcat_order_8121
#	$6	Environmental 环境			fx: unit | stage | prod | online 
#	$7	oper	项目分类			fx: java | php | static | ruby
#       $8	branch name 分支名称			fx: if $7==ruby $8=branch name   --> fueture_xxx | manster | tag

#echo $1 $2 $3 $4 $5 $6 $7

script_CodePath="/usr/local/websrv/jenkins/jenkinsworkspace/online/script"

# java项目copy部署和重启脚本
if [ "$7" = "java" ]; then
    rm -rf $1/jenkins/jenkinsworkspace/online/.jenkins/workspace/$2/auto*.sh
    rm -rf $1/jenkins/jenkinsworkspace/online/.jenkins/workspace/$2/target/*.war
    
    cp -rf $1/jenkins/jenkinsworkspace/online/script/deploy.sh $1/jenkins/jenkinsworkspace/online/.jenkins/workspace/$2
    cp -rf $1/jenkins/jenkinsworkspace/online/script/restart.sh $1/jenkins/jenkinsworkspace/online/.jenkins/workspace/$2
    cp -rf $1/jenkins/jenkinsworkspace/online/script/tomcat_init.sh $1/jenkins/jenkinsworkspace/online/.jenkins/workspace/$2
fi

####  ruby项目的部署&单元测试 等发布##########
if [ "$7" = "ruby" ]; then
    source "/usr/local/rvm/scripts/rvm"
    # Use the correct ruby
    #[[ -s ".rvmrc" ]] && source .rvmrc
    #Set "fail on error" in bash
    set -e
    # Do any setup
    # e.g. possibly do 'rake db:migrate db:test:prepare' here
    bundle install
    
    if [ "$6" = "unit" ]; then
        rake db:test:prepare
        rake
    fi
    
    if [ "$6" = "stage" ]; then
        if [ ! -d "$1/jenkins/jenkinsworkspace/stage/.jenkins/$2/workspace/node_modules" ]; then
            npm install
        fi
        bundle exec cap staging deploy
    fi
    
    if [ "$6" = "prod" ]; then
        if [ ! -d "$1/jenkins/jenkinsworkspace/online/.jenkins/workspace/$2/node_modules" ]; then
            npm install
        fi
        bundle exec cap prod deploy
    fi
    
    if [ "$6" = "online" ]; then
        if [ ! -d "$1/jenkins/jenkinsworkspace/online/.jenkins/workspace/$2/node_modules" ]; then
            npm install
        fi
        if [ "$8" = "-1" ]; then
            cap deploy:rollback
        else
            bundle exec cap production deploy tag=$8
        fi
    fi
fi

# 扫描代码库中文件的超级链接
sh $script_CodePath/scan.sh $2 
