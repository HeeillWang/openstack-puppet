#Enable the OpenStack repository
sudo yum install -y centos-release-openstack-liberty
sudo yum install -y https://rdoproject.org/repos/openstack-liberty/rdo-release-liberty.rpm

#Finalize the installation
sudo yum upgrade
sudo yum install -y python-openstackclient
sudo yum install -y openstack-selinux


