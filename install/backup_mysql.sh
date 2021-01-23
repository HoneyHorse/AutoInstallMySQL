#! /bin/bash

##uninstall mysql
echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Start to uninstall MySQL server..."
port=`netstat -nlt|grep 3306|wc -l`
cur_dir=`pwd`
if [ $port -eq 1 ];then
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` MySQL port 3306 had been occupied...plz check the service environment..."
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Stop MySQL server..."
    /usr/local/mysql/support-files/mysql.server stop
fi

process=`ps -ef|grep mysql|grep -v grep|grep -v backup_mysql.sh|grep -v install_mysql.sh|grep -v uninstall_mysql.sh|wc -l`
if [ $process -ne 0 ];then
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Some MySQL processes is exists...plz check the service environment..."
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Stop MySQL server..."
    /usr/local/mysql/support-files/mysql.server stop
fi

process_h=`ps -ef|grep mysql|grep -v grep|grep -v backup_mysql.sh|grep -v install_mysql.sh|grep -v uninstall_mysql.sh|wc -l`
if [ $process_h -ne 0 ];then
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Some MySQL processes is exists...plz check the service environment..."
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Stop MySQL server..."
    pid=`ps -ef|grep mysql|grep -v grep|grep -v backup_mysql.sh|grep -v uninstall_mysql.sh|grep -v install_mysql.sh|awk '{print $2}'`
    for id in ${pid}
    do
        kill -9 ${id}
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` killed ${id}"
    done

fi

if [ -d "/usr/local/mysql" ]; then
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` exist mysql file...now delete this file..."    
    rm -rf /usr/local/mysql
fi

egrep "^mysql" /etc/passwd &> /dev/null
if [ $? -eq 0 ]; then
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` exist mysql user...now delete mysql user..."
    userdel -r mysql
fi

if [ -f "/etc/my.cnf_bak" ]&&[ -f "/etc/my.cnf" ]
then
    rm -rf /etc/my.cnf
    cp /etc/my.cnf_bak /etc/my.cnf
    rm -rf /etc/my.cnf_bak
fi

if [ -f "/etc/my.cnf_bak" ]&&[ ! -f "/etc/my.cnf" ]
then
    cp /etc/my.cnf_bak /etc/my.cnf
    rm -rf /etc/my.cnf_bak
fi

##判断是否存在storagedir.txt，如果存在即代表mysql数据目录不是安装在默认的/opt/mysql下的，安装的具体目录在storagedir.txt文件里
if [ -f "${1}/storagedir.txt" ]; then
    storagedir=`cat ${1}/storagedir.txt`
    if [ -d ${storagedir} ]; then
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Start to DELETE ${storagedir}....."
        rm -rf ${storagedir}
    fi
    defaultdir="\/opt\/mysql"
    newdir=${storagedir//\//\\/}
    sed -i "s/$newdir/$defaultdir/" ${1}/my.cnf
    rm -rf ${1}/storagedir.txt
else
    if [ -d "/opt/mysql" ]; then
        rm -rf /opt/mysql/*
    fi
fi

rm -rf ${1}/storagedir.txt


if [ -f "/etc/profile_bak" ]&&[ -f "/etc/profile" ]
then
    rm -rf /etc/profile
    cp /etc/profile_bak /etc/profile
    rm -rf /etc/profile_bak
fi

if [ -f "/etc/profile_bak" ]&&[ ! -f "/etc/profile" ]
then
    cp /etc/profile_bak /etc/profile
    rm -rf /etc/profile_bak
fi

echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` ######Now LINUX SERVER ENV is BACKUP success..Thanks!!!!!!!.."
echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` ######Now LINUX SERVER ENV is BACKUP success..Thanks!!!!!!!.."
echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` ######Now LINUX SERVER ENV is BACKUP success..Thanks!!!!!!!.."
echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` ######Now LINUX SERVER ENV is BACKUP success..Thanks!!!!!!!.."
echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` ######Now LINUX SERVER ENV is BACKUP success..Thanks!!!!!!!.."
