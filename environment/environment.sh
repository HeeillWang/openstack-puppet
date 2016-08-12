#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#installing step
./MySQL/mariadb.sh
./NoSQL/nosql.sh
./ntp/ntp.sh
./openstack-package/openstack-package.sh
./rabbitmq/rabbitmq.sh
