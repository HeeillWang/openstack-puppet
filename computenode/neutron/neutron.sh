DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

puppet apply neutron-pakage.pp
puppet apply neutron-conf.pp
puppet apply neutron-ovs.pp
