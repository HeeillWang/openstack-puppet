#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#export environment variable FACTERLIB
export FACTERLIB="$DIR/custom_facts"

#installing step
sudo puppet apply ./host/host.pp
./ntp/ntp.sh
./openstack-package/openstack-package.sh
./MySQL/mariadb.sh
./NoSQL/nosql.sh
./rabbitmq/rabbitmq.sh

