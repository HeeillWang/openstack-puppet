

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
echo 'install git...'
ssh compute 'yum install -y git'
echo 'git cloning...'
ssh compute 'cd /root;git clone https://github.com/showx123/openstack-puppet'
echo 'answer file copy...'
scp $DIR/../answer.txt root@compute:/root/openstack-puppet/answer.txt
echo 'run puppet-install.sh...'
ssh -t compute 'source openstack-puppet/puppet-install.sh'
echo 'run environment.sh...'
ssh -t compute 'source openstack-puppet/environment/environment.sh'
echo 'run compute.sh...'
ssh -t comptue 'source openstack-puppet/compute/compute.sh'
