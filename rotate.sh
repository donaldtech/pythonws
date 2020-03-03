#!/bin/bash

# log/short_term_log.gz --> rotate
# log/short_term_log/simple_buffer.log --> delete

log_path=/Users/admin/fluentd/log
log_file_num=1
rotate_point=`expr $log_file_num + 1`

# param: short|long
rotate(){ 
  # file num greater than rotating point
  file_num=`ls $1*.gz 2> /dev/null | wc -l`
  if [ $file_num -gt 2 ];then
    difference=`expr $file_num - 2`
    ls -rt $1*.gz 2> /dev/null|awk 'NR==1,NR=="'$difference'"{print $1}' | xargs rm -f
  fi

  # file num to rotate point
  if [ $file_num -eq 2 ];then
    ls -rt $1*.gz 2> /dev/null|awk 'NR==1{print $1}' | xargs rm -f
  fi
}

while true;do  
  cd $log_path
  rotate short
  #rotate long
  
  cd $log_path/short_term_log
  ls simple*.log 2> /dev/null | xargs rm -f

  #cd $log_path/long_term_log
  #ls simple*.log 2> /dev/null | xargs rm -f
done
