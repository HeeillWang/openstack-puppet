set -e

echo "Start installation neutron in compute-node"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

puppet apply neutron-package.pp
puppet apply neutron-conf.pp
puppet apply neutron-ovs.pp
puppet apply ifcfg-br.pp
puppet apply nova-conf.pp

systemctl restart network
systemctl restart openstack-nova-compute
systemctl restart neutron-openvswitch-agent

echo "Completed installation neutron in compute-node without error"
