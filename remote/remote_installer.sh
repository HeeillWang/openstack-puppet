#!/bin/bash

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

echo '			install git...'
ssh compute 'yum install -y git'
echo '			git cloning...'
ssh compute 'cd /root;git clone https://github.com/showx123/openstack-puppet'
echo '			Copy anser file...'
scp $DIR/../answer.txt root@compute:/root/openstack-puppet/answer.txt
echo '			run puppet-install.sh...'
ssh -t compute './openstack-puppet/puppet-install.sh'
echo '			run environment.sh...'
ssh -t compute './openstack-puppet/environment/environment.sh'
echo '			run compute.sh...'
ssh -t compute './openstack-puppet/computenode/compute.sh'
echo "			Compute-node remote install completed!"
