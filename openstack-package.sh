#Enable the OpenStack repository
puppet apply openstack-package1.pp

#Finalize the installation
sudo yum upgrade
puppet apply openstack-package2.pp
