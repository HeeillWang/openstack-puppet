#Install the packages
sudo yum install -y openstack-nova-compute sysfsutils
sudo puppet apply nova_conf.pp
sudo systemctl enable libvirtd.service openstack-nova-compute.service
sudo systemctl start libvirtd.service openstack-nova-compute.service
