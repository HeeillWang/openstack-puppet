#!/bin/bash
set -e

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Database Setting
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "CREATE DATABASE neutron"
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'NEUTRON_DBPASS'"
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'controller' IDENTIFIED BY 'NEUTRON_DBPASS'"
mysql -u root -p"KEYSTONE_DBPASS" mysql -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'NEUTRON_DBPASS'"

source /root/admin-openrc.sh

for((i=0;i<COLUMNS;i++))do
	echo -n '-'
done
echo 'Create Openstack User: neutron...'
openstack user create --domain default --password skcc1234 neutron

for((i=0;i<COLUMNS;i++))do
	echo -n '-'
done
echo 'Add Role Admin To Uuser: neutron...'
openstack role add --project service --user neutron admin

for((i=0;i<COLUMNS;i++))do
	echo -n '-'
done
echo 'Create Openstack Service: neutron...'
openstack service create --name neutron --description "OpenStack Networking" network

for((i=0;i<COLUMNS;i++))do
        echo -n '-'
done
echo 'Create Service Endpoint: neutron...'
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696

echo 'OpenVswitch Settings'
puppet apply ifcfg-br.pp
#ovs-vsctl add-br br-public
#ovs-vsctl add-br br-private

echo 'Set configure files...'
puppet apply neutron_package.pp
puppet apply neutron_conf.pp
puppet apply ml2_agent.pp
puppet apply ovs_agent.pp
puppet apply l3_agent.pp
puppet apply dhcp_agent.pp
puppet apply metadata.pp

echo 'Make symbolic link...'
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

echo 'Populate database...'
/bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

systemctl restart network

systemctl restart openstack-nova-api.service
systemctl enable neutron-server.service neutron-openvswitch-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service neutron-l3-agent.service
systemctl start neutron-server.service neutron-openvswitch-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service neutron-l3-agent.service
systemctl restart neutron-server.service neutron-openvswitch-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service neutron-l3-agent.service

