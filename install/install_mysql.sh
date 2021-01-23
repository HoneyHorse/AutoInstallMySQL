#! /bin/bash

##This shell script use to auto install MySQL 5.7.19 on centos 7 release

##check environment
##$2 is mysql data storage directory,default data storage directory /opt/mysql
##$1 is choose single mysql install or cluster mysql install

if [ "$1" == "--help" ]; then 
    echo "Usage: install_mysql [OPTION...] [chapter] Manual pages...
              
    -C,--choose=选择安装类型   Single machine mysql installation and Cluster mysql installation,1 means Single,2 means Cluster
    -D,--directory=数据安装目录 mysql Data storage directory,plz input Absolute PATH,if no this parmar,will install in Default directory /opt/mysql
     
    -S,--silent=静默安装 NO Input CONFIG,need first config cluster/cluster.config file
 
    Report bugs to HoneyHorseGithub@163.com,Welcome to contact!!!"
    exit
fi


##get the current directory
cur_dir=`pwd`
echo "ffffffff"${cur_dir}
sleep 10
##check -C parmar
function check_parmarC(){
        if [ "$1" == "-C" ]; then
            if [ $2 -eq 1 ]; then
                return 1 ##single
               
            #echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` start to install one single mysql server"    
            #tar -zxvf mysql-5.7.19-linux-glibc2.12-x86_64.tar.gz -C /usr/local
            #mv /usr/local/mysql-5.7.19-linux-glibc2.12-x86_64 /usr/local/mysql
            fi

           if [ $2 -eq 2 ]; then
               return 2 ##cluster
           #echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` start to install the cluster mysql server"    
           #tar -C /usr/local -xzvf cluster/mysql-cluster-gpl-7.5.10-linux-glibc2.12-x86_64.tar.gz
           #ln -s /usr/local/mysql-cluster-gpl-7.5.10-linux-glibc2.12-x86_64 /usr/local/mysql
           fi
           echo "Please use ./install_mysql --help to see how to install mysql"
           exit
        else
           echo "Please use ./install_mysql --help to see how to install mysql"
           exit
        fi
}


##check -D parmar
function check_parmarD(){
    if [ "$1" ]; then
        if [ "$1" == "-D" ]; then
            if [ "$2" ];then
                storagedir=$2
                return 4
            #echo $storagedir > ${cur_dir}/storagedir.txt
            #defaultdir="\/opt\/mysql"
            #newdir=${storagedir//\//\\/}
            #sed -i "s/$defaultdir/$newdir/" ${cur_dir}/my.cnf
            else
                echo "Please use ./install_mysql --help to see how to install mysql"
                exit
            fi
        else
            echo "Please use ./install_mysql --help to see how to install mysql"
            exit
        fi
    else
        storagedir="/opt/mysql"
        return 2
    fi
}

##check -I parmar
#function check_parmarI(){
##
#}

function check_env()
{
    mysqlgroup=`egrep "^mysql" /etc/group`
    if [ $? -eq 0 ]; then
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` exists mysql group...plz check the service environment..."
        return 2
    fi

    mysqluser=`egrep "^mysql" /etc/passwd`
    if [ $? -eq 0 ]; then
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` exists mysql user...plz check the service environment..."
        return 2
    fi
    type netstat >/dev/null 2>&1 || { echo >&2 "Netstat Command not Install,PLZ Instalit it.....................";exit 1;}  
    port=`netstat -nlt|grep 3306|wc -l`
    process=`ps -ef|grep mysql|grep -v grep|grep -v install_mysql.sh|wc -l`
    if [ $port -eq 1 ];then
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` MySQL port 3306 had been occupied...plz check the service environment..."
        return 2
    fi

    if [ $process -ne 0 ];then
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Some MySQL processes is exists...plz check the service environment..."
        return 2
    fi
    
    if [ `whoami` != "root" ];then
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` current user is `whoami`,plz change to root user to install..."
        return 2
    fi

    if [ `getconf LONG_BIT` -ne 64 ];then
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` current system is `getconf LONG_BIT`,plz change to 64 system to install..."
        return 2
    fi

}

##check parmar -C
if [ "$1" ]; then
    if [ "$2" ]; then
        ${cur_dir}/check_num.sh -i $2
        res_num=$?
        if [ ${res_num} -eq 1 ]; then
            echo "Please use ./install_mysql --help to see how to install mysql"
            exit
        fi 
        check_parmarC $1 $2
        parmarC=$?
    else
        echo "Please use ./install_mysql --help to see how to install mysql"
        exit
    fi
else
    echo "Please use ./install_mysql --help to see how to install mysql"
    exit
fi

##check parmar -D
check_parmarD $3 $4
parmarD=$?

##check environment
check_env
if [ $? -eq 2 ]; then
    exit
fi

if [ ${parmarC} -eq 1 ]; then

    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Install Environment is OK!!!................"
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Now Start to Install One Single MySQL Server"    
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Now First Step Start to Unzip MySQL Zip File..."

    if [ ! -f "mysql-5.7.19-linux-glibc2.12-x86_64.tar.gz" ]; then
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Cann't Find MySQL Zip Package,PLZ CHECK....."
        exit
    fi
    tar -zxvf mysql-5.7.19-linux-glibc2.12-x86_64.tar.gz -C /usr/local
    mv /usr/local/mysql-5.7.19-linux-glibc2.12-x86_64 /usr/local/mysql

    if [ ${parmarD} -eq 4 ]; then
        echo $storagedir > ${cur_dir}/storagedir.txt
        defaultdir="\/opt\/mysql"
        newdir=${storagedir//\//\\/}
        sed -i "s/$defaultdir/$newdir/" ${cur_dir}/my.cnf
    fi

    if [ -f "/etc/my.cnf" ]; then
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` exists my.cnf,now backup the my.cnf..."
        cp /etc/my.cnf /etc/my.cnf_bak
        cp ${cur_dir}/my.cnf /etc/my.cnf
    else
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` not exists my.cnf,now copy the my.cnf into /etc directory..."
        cp ${cur_dir}/my.cnf /etc/my.cnf
     fi

fi

if [ ${parmarC} -eq 2 ]; then

    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Install SQL node(mysqld) Environment is OK!!!................"
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Now Start to Install Cluster MySQL Server"    
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Now First Step Start to Unzip MySQL Zip File..."
    if [ ! -f "cluster/mysql-cluster-gpl-7.5.10-linux-glibc2.12-x86_64.tar.gz" ]; then
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Cann't Find MySQL Zip Package,PLZ CHECK....."
        exit
    fi
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` start to install the cluster mysql server"    
    tar -C /usr/local -xzvf cluster/mysql-cluster-gpl-7.5.10-linux-glibc2.12-x86_64.tar.gz
    ln -s /usr/local/mysql-cluster-gpl-7.5.10-linux-glibc2.12-x86_64 /usr/local/mysql 

    if [ ${parmarD} -eq 4 ]; then
        echo $storagedir > ${cur_dir}/storagedir.txt
        defaultdir="\/opt\/mysql"
        newdir=${storagedir//\//\\/}
        sed -i "s/$defaultdir/$newdir/" ${cur_dir}/cluster/my.cnf
    fi

    if [ -f "/etc/my.cnf" ]; then
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` exists my.cnf,now backup the my.cnf..."
        cp /etc/my.cnf /etc/my.cnf_bak
        cp ${cur_dir}/cluster/my.cnf /etc/my.cnf
    else
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` not exists my.cnf,now copy the my.cnf into /etc directory..."
        cp ${cur_dir}/cluster/my.cnf /etc/my.cnf
     fi

fi



cd /usr/local/mysql
##add mysql group
egrep "^mysql" /etc/group >& /dev/null
if [ $? -ne 0 ]; then
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` not exists mysql group,now create mysql group..."    
    groupadd mysql
fi
##add mysql user 
egrep "^mysql" /etc/passwd
if [ $? -ne 0 ]; then
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` not exists mysql user,now create mysql user..."
    useradd mysql -g mysql
fi



##create the data file
if [ ! -d ${storagedir} ]; then
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` ${storagedir} directory is not exist,now create ${storagedir} directory..."
    mkdir -p ${storagedir}
    mkdir ${storagedir}/data
    mkdir ${storagedir}/log
    cp -R /usr/local/mysql/share ${storagedir}
    cp -R /usr/local/mysql/bin ${storagedir}
    chown -R mysql:mysql ${storagedir}
else
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` ${storagedir} directory is exist,now chown mysql:mysql to ${storagedir}..."
    mkdir ${storagedir}/data
    mkdir ${storagedir}/log
    cp -R /usr/local/mysql/share ${storagedir}
    cp -R /usr/local/mysql/bin ${storagedir} 
    chown -R mysql:mysql ${storagedir}
fi

chown -R mysql .
chgrp -R mysql .


echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Start to init the mysql service..."
bin/mysqld --initialize --user=mysql --basedir=${storagedir} --datadir=${storagedir}/data

if [ ! -f ${storagedir}/log/mysql-error.log ]; then

    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` ERROR:Init MySQL Server has ERROR........plz Check init logs"  
    echo "#####NOW START TO BACKUP.............."
    echo "#####NOW START TO BACKUP.............."
    echo "#####NOW START TO BACKUP.............."
    echo "#####NOW START TO BACKUP.............."
    echo "#####NOW START TO BACKUP.............."
    ${cur_dir}/backup_mysql.sh ${cur_dir}
    exit
fi

if [ -f ${storagedir}/log/mysql-error.log ]; then

    error_num=`cat ${storagedir}/log/mysql-error.log|grep ERROR|wc -l`
    if [ ${error_num} -gt 0 ]; then
        echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` ERROR:Init MySQL Server has ERROR........plz Check init logs"
        cp ${storagedir}/log/mysql-error.log ${cur_dir}/
        echo "#####NOW START TO BACKUP.............."
        echo "#####NOW START TO BACKUP.............."
        echo "#####NOW START TO BACKUP.............."
        echo "#####NOW START TO BACKUP.............."
        echo "#####NOW START TO BACKUP.............."
        ${cur_dir}/backup_mysql.sh ${cur_dir}
        exit
    fi

fi

echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Get the password from mysql-error.log..."
passwd=`grep -i password ${storagedir}/log/mysql-error.log |head -n1|awk -F 'root@localhost: ' '{print $2}'`
echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` The init password is :${passwd}"

echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Start MySQL server..."
/usr/local/mysql/support-files/mysql.server start

##set mysql command environment
if [ -f "/etc/profile" ]; then
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` profile is exsit,now backup the profile..."
    cp /etc/profile /etc/profile_bak
    mysql_path=`cat /etc/profile|grep \$PATH:/usr/local/mysql/bin|wc -l`
    if [ ${mysql_path} -eq 0 ]; then 
        echo "export PATH=\$PATH:/usr/local/mysql/bin/" >> /etc/profile
    fi
    source /etc/profile
else
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` profile is not exsit,now generater profile..."
    cp ${cur_dir}/profile /etc/profile
    source /etc/profile
fi

##execute the init MySQL password
port=`netstat -nlt|grep 3306|wc -l`
process=`ps -ef|grep mysql|grep -v grep|grep -v install_mysql.sh|grep -v uninstall_mysql.sh|wc -l`
if [ ${port} -eq 1 ]&&[ ${process} -ne 0 ]
then
    echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` MySQl server is running..now change the init mysql passwd to default aaron..."
    ${cur_dir}/change_passwd.sh ${cur_dir} ${storagedir} &>/dev/null
fi

echo "`date +%Y-%m-%dC%T|sed 's/C/ /g'` Now MySQL server is install success...You can use it now..Thanks..."

##set the boot to start automatically mysql server
cd /usr/local/mysql/
cp support-files/mysql.server /etc/rc.d/init.d/
chmod +x /etc/rc.d/init.d/mysql.server
chkconfig --add mysql.server

