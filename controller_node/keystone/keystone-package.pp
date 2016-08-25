class keystone_package{
   package{'openstack-keystone':}->
   package{'httpd':}->
   package{'mod_wsgi':}->
   package{'memcached':}->
   package{'python-memcached':}
}
service{'memcached.service':
   ensure   => running,
   enable   => true,
}

include keystone_package

Class['keystone_package'] -> Service['memcached.service']
