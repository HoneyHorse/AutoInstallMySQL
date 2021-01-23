#! /bin/bash

cur_dir=$1
storagedir=$2
passwd=`grep -i password ${storagedir}/log/mysql-error.log |head -n1|awk -F 'root@localhost: ' '{print $2}'`
##change passwd to default aaron
/usr/local/mysql/bin/mysql -uroot -p${passwd} --connect-expired-password -e "source ${cur_dir}/change_passwd.sql"

/usr/local/mysql/bin/mysql -uroot -paaron -e "source ${cur_dir}/open_remote_log.sql"

