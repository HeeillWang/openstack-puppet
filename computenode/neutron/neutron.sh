DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
pwd

puppet apply neutron-package.pp
puppet apply neutron-conf.pp
puppet apply neutron-ovs.pp
