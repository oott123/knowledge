# install supervisord and shadowsocks
set -e
set -o pipefail

if ! which supervisorctl >/dev/null
then
  wget https://raw.githubusercontent.com/oott123/knowledge/master/op/scripts/supervisord/install.sh -O - | bash
fi

if ! which pip >/dev/null
then
  yum install -y wget ca-certificates python-pip
fi

pip install shadowsocks
wget https://raw.githubusercontent.com/oott123/knowledge/master/op/scripts/shadowsocks/shadowsocks.ini -O /etc/supervisor.d/shadowsocks.ini
sed -i "s:#ssserver#:`which ssserver`:" /etc/supervisor.d/shadowsocks.ini
wget https://raw.githubusercontent.com/oott123/knowledge/master/op/scripts/shadowsocks/shadowsocks.json -O /etc/shadowsocks.json

SSPORT=`shuf -i 2000-65000 -n 1`
SSPWD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1`
read -p "Input password or we will generate one for you: "
if [[ $REPLY ]]
then
  SSPWD=`echo -e $REPLY | tr -d '[[:space:]]'`
fi
sed -i "s/#port#/$SSPORT/" /etc/shadowsocks.json
sed -i "s/#password#/$SSPWD/" /etc/shadowsocks.json
useradd shadowsocks
service supervisord restart
echo "============================="
echo "     Installation success    "
echo "============================="
echo " * Your shadowsocks password is $SSPWD"
echo " * Now you can connect with your server ip and port $SSPORT"
echo " * Have fun!"
