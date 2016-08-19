class glance_regi($path = '/etc/glance/glance-registry.conf'){
	file_line{'connection':
		path	=> $path,
		match	=> '#connection=',
		line	=> 'connection = mysql://glance:GLANCE_DBPASS@controller/glance'
	}
	
	if file($path) =~ /auth_plugin/{}
	else {
		file_line {'authtoken':
			path	=> $path,
			match	=> '\[keystone_authtoken\]',
			line	=>
'[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = glance
password = skcc1234
',
		}
	}
	
	file_line {'flavor':
		path	=> $path,
		match	=> '#flavor',
		line	=> 'flavor = keystone',
	}
	
	file_line {'notification_driver':
		path	=> $path,
		match	=> '#notification_driver',
		line	=> 'notification_driver = noop',
	}
	
}

service {'openstack-glance-api':
	ensure	=> running,
	enable	=> true,
}

service {'openstack-glance-registry':
	ensure	=> running,
	enable	=> true,
}

include glance_regi
