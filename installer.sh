set -e

#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

./puppet-install.sh
./environment/environment.sh
./controller_node/controller.sh
./computenode/compute.sh
./storage_node/cinder/cinder.sh
