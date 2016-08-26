file_line{ 'verbose':
	path	=> '/etc/neutron/neutron.conf',
	match	=> '# verbose',
	line	=> 'verbose = True',
}

file_line{ 'auth_strategy':
	path	=> '/etc/neutron/neutron.conf',
	match	=> '# auth_strategy',
	line	=> 'auth_strategy = keystone',
}

file_line{ 'rpc_backend':
	path	=> '/etc/neutron/neutron.conf',
	match	=> '# rpc_backend',
	line	=> 'rpc_backend=rabbit',
}

file_line{ 'lock_path':
	path	=> '/etc/neutron/neutron.conf',
	match	=> '# lock_path',
	line	=> 'lock_path = /var/lib/neutron/tmp',
}

file_line{ 'rabbit_host':
	path	=> '/etc/neutron/neutron.conf',
	match	=> '# rabbit_host = localhost',
	line	=> 'rabbit_host = controller',
}

file_line{ 'rabbit_userid':
	path	=> '/etc/neutron/neutron.conf',
	match	=> '# rabbit_userid = guest',
	line	=> 'rabbit_userid = openstack',
}

file_line{ 'rabbit_password':
	path	=> '/etc/neutron/neutron.conf',
	match	=> '# rabbit_password = guest',
	line	=> "rabbit_password = $rabbit_pass",
}

if file("/etc/neutron/neutron.conf") =~ /auth_uri = http:\/\/127.0.0.1/{
	file_line{ 'auth_uri':
		path	=> '/etc/neutron/neutron.conf',
		match	=> 'auth_uri',
		line	=> 
'auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password',
	}
}

if file("/etc/neutron/neutron.conf") =~ /^admin_tenant_name/{
	file_line{ 'admin_tenant_name':
		path	=> '/etc/neutron/neutron.conf',
		match	=> '^admin_tenant_name',
		line	=> 
'project_domain_id = default
user_domain_id = default
project_name = service',
	}
}

file_line{ 'admin_user':
	path	=> '/etc/neutron/neutron.conf',
	match	=> '^admin_user',
	line	=> 'username = neutron',
}

file_line{ 'admin_password':
	path	=> '/etc/neutron/neutron.conf',
	match	=> '^admin_password',
	line	=> "password = $neutron_authpass",
}
