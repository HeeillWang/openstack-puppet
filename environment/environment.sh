#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#export environment variable FACTERLIB
export FACTERLIB="$DIR/custom_facts"

#installing step
./MySQL/mariadb.sh
./NoSQL/nosql.sh
./ntp/ntp.sh
./openstack-package/openstack-package.sh
./rabbitmq/rabbitmq.sh
sudo puppet apply ./host/host.pp
