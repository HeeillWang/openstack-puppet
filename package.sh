set -e
yum install chrony

yum install centos-release-openstack-liberty
yum install https://rdoproject.org/repos/openstack-liberty/rdo-release-liberty.rpm || true
yum upgrade
yum install python-openstackclient
yum install openstack-selinux

yum install mariadb mariadb-server MySQL-python

yum install openstack-keystone httpd mod_wsgi \
  memcached python-memcached

yum install openstack-glance python-glance python-glanceclient

yum install openstack-nova-api openstack-nova-cert \
  openstack-nova-conductor openstack-nova-console \
  openstack-nova-novncproxy openstack-nova-scheduler \
  python-novaclient

yum install openstack-nova-compute sysfsutils

yum install openstack-neutron openstack-neutron-ml2 \
  openstack-neutron-openvswitch python-neutronclient ebtables ipset

yum install openstack-neutron openstack-neutron-openvswitch ebtables ipset

yum install openstack-dashboard

yum install openstack-cinder python-cinderclient

yum install lvm2
