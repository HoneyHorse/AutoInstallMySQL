#! /bin/bash  
floatExp="^(-?\d+)(\.\d+)?$"  
intExp="^-?\d+$"  
exp=""  
exp=${intExp}  
if [ $# != 2 ] ; then  
 echo wrong arg nums,please input one arg  
 exit 1  
fi  
  
case $1 in  
"-f")  
   exp=${floatExp}  
        ;;  
"-i")  
  exp=${intExp}  
        ;;  
*)  
   echo option shuld be -i or -f  
   exit 1  
        ;;  
esac  
  
  
if [ `echo $2|grep -P "${exp}"|wc -l` == 1  ] ; then  
  # echo num $2  
   exit 0;  
  else  
   # echo not num  
    exit 1;  
fi  
