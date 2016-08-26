set -e

echo "Start install openstack-package"

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

#Enable the OpenStack repository
yum install -y centos-release-openstack-liberty
sudo yum install -y https://rdoproject.org/repos/openstack-liberty/rdo-release-liberty.rpm || true

#Finalize the installation
sudo yum upgrade -y
puppet apply openstack-package.pp

echo "Openstack-package install completed!"
