# install supervisord and shadowsocks
set -e
set -o pipefail

if ! which supervisorctl >/dev/null
then
  wget https://raw.githubusercontent.com/oott123/knowledge/master/op/scripts/supervisord/install.sh -O - | bash
fi

if ! which pip >/dev/null
then
  yum install -y python-pip
fi

pip install shadowsocks
useradd shadowsocks
