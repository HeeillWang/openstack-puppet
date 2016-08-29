set -e

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

./keystone/keystone.sh
#./glance/glance.sh
./nova/nova.sh
./neutron/neutron.sh
./horizon/horizon.sh
./cinder/cinder.sh
