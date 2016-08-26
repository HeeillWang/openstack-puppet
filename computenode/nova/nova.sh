set -e

echo "Start Install nova in compute-node"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

#Install the packages
puppet apply nova-package.pp

#Configuration
puppet apply nova_conf.pp

#Start and Enable the services
sudo systemctl enable libvirtd.service openstack-nova-compute.service
sudo systemctl start libvirtd.service openstack-nova-compute.service

echo "Completed install nova in compute-node without error"
