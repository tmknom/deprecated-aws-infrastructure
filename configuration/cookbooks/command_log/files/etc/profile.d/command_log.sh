#!/bin/sh
#
# command log script
#
# Linux/UNIX 上でコマンドの実行履歴を残す方法
# http://www.drk7.jp/MT/archives/000988.html
#
# ログを見やすくするコマンド
# col -bx < [log_file] | less
#
# 事前に作成しておく必要あり
# /bin/mkdir ${LOG_DIR}
# /bin/chmod 1777 ${LOG_DIR}

LOG_DIR=/var/log/command

year=`/bin/date +%Y`
month=`/bin/date +%m`
now=`/bin/date +%Y-%m-%dT%H:%M:%S.%N`

user=`/usr/bin/whoami`

if [ ! -d ${LOG_DIR}/${year} ]; then
  /bin/mkdir -m 777 ${LOG_DIR}/${year}
fi
if [ ! -d ${LOG_DIR}/${year}/${month} ]; then
  /bin/mkdir -m 777 ${LOG_DIR}/${year}/${month}
fi

logfile=${LOG_DIR}/${year}/${month}/${now}.${user}.log

p_proc=`/bin/ps -ef | /bin/grep ${PPID} | /bin/grep bash | /bin/awk '{print $8}'`
if [ "$p_proc" = -bash ]; then
  /usr/bin/script -q ${logfile}
  exit
fi
