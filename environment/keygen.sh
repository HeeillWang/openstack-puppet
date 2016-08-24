ssh-keygen -t rsa -N "" -f ~/.ssh/my_key

chmod 700 ~/.ssh
chmod 600 ~/.ssh/my_key
chmod 644 ~/.ssh/my_key.pub
chmod 644 ~/.ssh/known_hosts

scp ~/.ssh/my_key.pub root@compute:~/my_key.pub

ssh compute "cat ~/my_key.pub > ~/.ssh/authorized_keys"
