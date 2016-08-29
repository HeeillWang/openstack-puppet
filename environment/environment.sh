echo "start install Environment"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#export environment variable FACTERLIB
export FACTERLIB="$DIR/custom_facts"


#if [ "$hostname" != "controller" ];then
#	hostnamectl set-hostname compute
#fi

#installing step
puppet apply ./host/host.pp

if [ -e /root/.ssh/id_rsa ];then
        echo "          RSA-key already exist! skip RSA-key generation"
else
        echo "          Generate RSA-key..."
        ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
fi

chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
chmod 644 ~/.ssh/known_hosts || true

echo '                  copy rsa-key to compute node'
ssh-copy-id root@controller
ssh-copy-id root@compute

./ntp/ntp.sh
./openstack-package/openstack-package.sh
./MySQL/mariadb.sh
./NoSQL/nosql.sh
ssh controller /root/openstack-puppet/environment/rabbitmq/rabbitmq.sh

echo "Environment install completed!"
