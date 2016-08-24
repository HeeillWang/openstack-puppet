git clone https://github.com/showx123/openstack-puppet

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#export environment variable FACTERLIB
export FACTERLIB="$DIR/../custom_facts"

source /root/openstack-puppet/computenode/nova/nova.sh
source /root/openstack-puppet/computenode/neutonr/neutron.sh

