set -e

echo "Start install rabbitmq!"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#Add custom facters
export FACTERLIB="$DIR/../../environment/custom_facts/"

puppet apply rabbitmq.pp

#add rabbitmq user and set permission
rabbitpass=$(cat $DIR/../../answer.txt | grep rabbit_pass)

if [ $(rabbitmqctl list_users | grep -w -o openstack) ];then
    echo "rabbitmq user 'openstack' already exists. skip add user..."
else
    echo "add rabbitmq user 'openstack'"
    rabbitmqctl add_user openstack ${rabbitpass:14}
    rabbitmqctl set_permissions openstack ".*" ".*" ".*"
fi

echo "RabbitMQ install completed!"
