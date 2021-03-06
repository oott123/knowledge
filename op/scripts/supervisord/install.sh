#!/bin/bash
#################################
#      Install supervisord      #
#                 By. oott123   #
#        FOR CENTOS ONLY        #
#     USE AT YOUR OWN RISK      #
#################################

# install via
# wget https://raw.githubusercontent.com/oott123/knowledge/master/op/scripts/supervisord/install.sh -O - | bash
# curl https://raw.githubusercontent.com/oott123/knowledge/master/op/scripts/supervisord/install.sh | bash

# 发生错误后终止
set -e
set -o pipefail

# 安装 pip
yum -y install epel-release # 有 epel-release 才能装 python-pip

yum -y install wget ca-certificates python-pip # wget 后面用到；ca-certificates 防止证书导致 wget 报错
if ! which pip >/dev/null
then
  exit 1
fi

# 安装 supervisord
pip install supervisor
if ! which supervisorctl >/dev/null
then
  exit 2
fi

# 下载 init.d 脚本
wget https://raw.githubusercontent.com/Supervisor/initscripts/master/redhat-init-mingalevme -O /etc/init.d/supervisord
chmod 700 /etc/init.d/supervisord

# 下载配置文件
wget https://raw.githubusercontent.com/oott123/knowledge/master/op/scripts/supervisord/supervisord.conf -O /etc/supervisord.conf
chmod 644 /etc/supervisord.conf
mkdir /etc/supervisord.d
chmod 755 /etc/supervisord.d
wget https://raw.githubusercontent.com/oott123/knowledge/master/op/scripts/supervisord/program.ini -O /etc/supervisord.d/program.ini
chmod 644 /etc/supervisord.d/program.ini

# 设置启动项
chkconfig supervisord on
