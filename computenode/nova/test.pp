#augeas { "test":
#  context => '/files/root/openstack-puppet/computenode/nova/test.txt',
#  changes => [
#    "set puppet yes",
#  ],
#}

file_line { 'someline':
  path     => '/root/openstack-puppet/computenode/nova/test.txt',
  match    => '#puppet',
  line     => 'puppet=yes',
  after    => '[default]',
  multiple => 'false',
}
