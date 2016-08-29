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
./ntp/ntp.sh
./openstack-package/openstack-package.sh
./MySQL/mariadb.sh
./NoSQL/nosql.sh
ssh controller /root/openstack-puppet/environment/rabbitmq/rabbitmq.sh

echo "Environment install completed!"
