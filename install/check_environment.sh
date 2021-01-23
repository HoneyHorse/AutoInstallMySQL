#! /bin/bash
##check install service environment
##check point mysql user..mysql group..

mysqlgroup=`egrep "^mysql" /etc/group`
if [ $? -eq 0 ]; then
    echo "exists mysql group...plz check the service environment..."
    return 1
fi
mysqluser=`egrep "^mysql" /etc/passwd`
if [ $? -eq 0 ]; then
    echo "exists mysql user...plz check the service environment..."
    return 1
fi
