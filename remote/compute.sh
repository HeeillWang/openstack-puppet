#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

git init openstack-puppet
cd openstack-puppet
git config core.sparseCheckout true
git remote add -f origin https://github.com/showx123/openstack-puppet
echo "computenode" >> .git/info/sparse-checkout
echo "environment" >> .git/info/sparse-checkout
echo "answer.txt" >> .git/info/sparse-checkout
git pull origin master

#export environment variable FACTERLIB
export FACTERLIB="$DIR/enviroment/custom_facts"

source computenode/nova/nova.sh
source computenode/neutorn/neutron.sh

