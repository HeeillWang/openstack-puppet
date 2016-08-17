#Move to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

sudo puppet apply nosql_package.pp
sudo puppet apply nosql_conf.pp

