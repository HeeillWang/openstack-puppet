$pathes = '/etc/openstack-dashboard/local_settings'

file_line { 'OPENSTACK_HOST':
	path	=> $pathes,
	match	=> '^OPENSTACK_HOST',
	line	=> 'OPENSTACK_HOST = "controller"',
}

file_line { 'ALLOWED_HOSTS':
	path	=> $pathes,
	match	=> 'ALLOWED_HOSTS',
	line	=> "ALLOWED_HOSTS = ['*',]",
}
if file($pathes) =~ /SESSION_ENGINE/{}
else{

file_line { 'CACHES':
	path	=> $pathes,
	match	=> '^CACHES',
	line	=>
"SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
CACHES = {"
}
file_line { 'BACKEND':
	path	=> $pathes,
	match	=> 'django.core.cache.backends.locmem.LocMemCache',
	line	=>
"         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
         'LOCATION': 'controller:11211',"
}
}

file_line {'OPENSTACK_KEYSTONE_URL':
	path	=> $pathes,
	match	=> 'OPENSTACK_KEYSTONE_URL',
	line	=> 'OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST',
}

file_line {'OPENSTACK_KEYSTONE_MULTIDOMAIN':
	path	=> $pathes,
	match	=> '#OPENSTACK_KEYSTONE_MULTIDOMAIN',
	line 	=> 'OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = False',
}

if file($pathes) =~ /\#OPENSTACK_API_VERSIONS/{
	file_line { 'OPENSTACK_API_VERSIONS':
		path	=> $pathes,
		match	=> '#OPENSTACK_API_VERSIONS',
		line	=> 'OPENSTACK_API_VERSIONS = {'	
	}
	file_line { 'data-processing':
		path	=> $pathes,
		match	=> 'data-processing',
		line	=> '    "image": 2,',
	}
	file_line { 'identity':
		path	=> $pathes,
		match	=> '"identity"',
		line	=> '    "identity": 3,',
	}
	file_line {'volume':
		path	=> $pathes,
		match	=> '"volume"',
		line	=> '    "volume": 2,
}'
	}
}

file_line {'OPENSTACK_KEYSTONE_DEFAULT_DOMAIN':
	path	=> $pathes,
	match	=> '#OPENSTACK_KEYSTONE_DEFAULT_DOMAIN',
	line	=> '#OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "default"',
}

file_line {'OPENSTACK_KEYSTONE_DEFAULT_ROLE':
	path    => $pathes,
        match   => 'OPENSTACK_KEYSTONE_DEFAULT_ROLE',
        line    => 'OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"',
}

if file($pathes) =~ /\'enable_ipv6\': True/{

file_line {'enable_router':
	path	=> $pathes,
	match	=> 'enable_router',
	line	=> "    'enable_router': True,",
}
file_line {'enable_quotas':
	path	=> $pathes,
	match	=> 'enable_quotas',
	line	=> "    'enable_quotas': False,",
}
file_line {'enable_ipv6':
	path	=> $pathes,
	match	=> 'enable_ipv6',
	line	=> "    'enable_ipv6': False,",
}
file_line {'enable_distributed_router':
	path	=> $pathes,
	match	=> 'enable_distributed_router',
	line	=> "    'enable_distributed_router': False,",
}
file_line {'enable_ha_router':
	path	=> $pathes,
	match	=> 'enable_ha_router',
	line	=> "    'enable_ha_router': False,",
}
file_line {'enable_lb':
	path	=> $pathes,
	match	=> 'enable_lb',
	line	=> "    'enable_lb': False,",
}
file_line {'enable_firewall':
	path	=> $pathes,
	match	=> 'enable_firewall',
	line	=> "    'enable_firewall': False,",
}
file_line {'enable_vpn':
	path	=> $pathes,
	match	=> 'enable_vpn',
	line	=> "    'enable_vpn': False,",
}
file_line {'enable_fip_topology_check':
	path	=> $pathes,
	match	=> 'enable_fip_topology_check',
	line	=> "    'enable_topology_check': False,",
}
}

file_line {'TIMEZONE':
	path	=> $pathes,
	match	=> 'TIME_ZONE',
	line	=> 'TIME_ZONE = "Asia/Seoul"',
}

