DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

puppet apply rabbitmq.pp

rabbitmqctl add_user openstack skcc1234

rabbitmqctl set_permissions openstack ".*" ".*" ".*"
