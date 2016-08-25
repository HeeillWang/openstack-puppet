#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
chmod 644 ~/.ssh/known_hosts

scp ~/.ssh/id_rsa.pub root@compute:~/id_rsa.pub
ssh compute 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa;cat ~/id_rsa.pub >> ~/.ssh/authorized_keys'

#scp compute.sh root@compute:~/compute.sh
#ssh compute "source compute.sh"

ssh compute 'yum install -y git'
ssh compute 'cd /root;git clone https://github.com/showx123/openstack-puppet'
ssh compute 'sudo source openstack-puppet/puppet-install.sh'
ssh compute 'sudo source openstack-puppet/environment/environment.sh'
ssh comptue 'sudo source openstack-puppet/compute/compute.sh'
