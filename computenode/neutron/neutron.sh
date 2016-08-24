DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

puppet apply neutron-package.pp
puppet apply neutron-conf.pp
puppet apply neutron-ovs.pp
puppet apply ifcfg-br.pp

systemctl restart network
systemctl restart openstack-nova-compute
systemctl restart neutron-openvswitch-agent
