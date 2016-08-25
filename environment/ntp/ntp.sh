DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
export FACTERLIB="$DIR/../custom_facts"

puppet apply ntp.pp


