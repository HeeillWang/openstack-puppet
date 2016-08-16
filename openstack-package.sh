#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Enable the OpenStack repository
puppet apply openstack-package1.pp
sudo yum install -y https://rdoproject.org/repos/openstack-liberty/rdo-release-liberty.rpm

#Finalize the installation
sudo yum upgrade -y
puppet apply openstack-package2.pp
