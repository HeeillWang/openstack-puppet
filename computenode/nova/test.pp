#augeas { "test":
#  context => '/files/root/openstack-puppet/computenode/nova/test.txt',
#  changes => [
#    "set puppet yes",
#  ],
#}
class abc(){
file_line { 'someline':
  path     => '/root/openstack-puppet/computenode/nova/test.txt',
  #ensure   => 'absent',
  match    => '12345',
  line     => 'puppet=yes',
  #match_for_absence  => 'true',
  #after    => '[default]',
  #multiple => 'false',
}
}

include abc
