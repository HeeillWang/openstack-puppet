ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
chmod 644 ~/.ssh/known_hosts

scp ~/.ssh/id_rsa.pub root@compute:~/id_rsa.pub
ssh compute 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa;cat ~/id_rsa.pub >> ~/.ssh/authorized_keys'

#ssh compute cat ~/id_rsa.pub >> ~/.ssh/authorized_keys"
