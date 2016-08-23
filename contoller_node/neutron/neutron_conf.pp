class neutron-conf($path = '/etc/neutron/neutron.conf'){
	file_line { 'connection':
		path	=> $path,
		match	=> '# connection = sqlite://',
		line	=> 'connection = mysql://neutron:NEUTRON_DBPASS@controller/neutron'
	}

	file_line { 'core_plugin':
		path	=> $path,
		match	=> '# core_plugin',
		line 	=> 'core_plugin = ml2',
	}

        file_line { 'service_plugins':
                path    => $path,
                match   => '# service_plugins',
                line    => 'service_plugins = router',
        }

        file_line { 'allow_overlapping':
                path    => $path,
                match   => '# allow_overlapping',
                line    => 'allow_overlapping_ips = True',
        }

	file_line { 'rpc_backend':
                path    => $path,
                match   => '# rpc_backend',
                line    => 'rpc_backend = rabbit',
        }

	file_line { 'rabbit_host':
                path    => $path,
                match   => '# rabbit_host = ',
                line    => 'rabbit_host = controller',
        }

	file_line { 'rabbit_userid':
                path    => $path,
                match   => '# rabbit_userid = ',
                line    => 'rabbit_userid = openstack',
        }

        file_line { 'rabbit_password':
                path    => $path,
                match   => '# rabbit_password = ',
                line    => 'rabbit_password = skcc1234',
        }

	file_line { 'auth_strategy':
                path    => $path,
                match   => '# auth_strategy = ',
                line    => 'auth_strategy = keystone',
        }
	if file($path) =~ /auth_uri = http:\/\/127.0.0.1:35357/{
        	file_line { 'auth_uri':
	                path    => $path,
	                match   => 'auth_uri',
                	line    =>
'auth_uri = http://controller:5000
auth_url = http://controller:35357',
        	}

		file_line { 'auth_plugin':
			path	=> $path,	
			match	=> 'identity_uri',
			line	=> 'auth_plugin = password',
		}
                file_line { 'project_domain_id':
                        path    => $path,
                        match   => '^admin_tenant_name',
                        line    => 'project_domain_id = default',
                }
                file_line { 'user_domain_id':
                        path    => $path,
                        match   => '^admin_user',
                        line    => 'user_domain_id = default',
                }
                file_line { 'project_name':
                        path    => $path,
                        match   => '^admin_password',
                        line    =>
'project_name = service
username = neutron
password = skcc1234',
                }
	}
	file_line { 'notify_nova_on_status_change':
		path	=> $path,
		match	=> '# notify_nova_on_port_status_changes',
		line	=> 'notify_nova_on_port_status_changes = True',
	}

	file_line {'notify_nova_on_port_data_changes':
		path    => $path,
                match   => '# notify_nova_on_port_data_changes',
                line    => 'notify_nova_on_port_data_changes = True',
	}

	file_line {'nova_url':
		path    => $path,
                match   => '# nova_url',
                line    => 'nova_url = http://controller:8774/v2',
	}

	if file($path) =~ /# auth_plugin/{
		file_line {'nova_section':
			path	=> $path,
			match	=> '\[nova\]',
			line	=> 
"[nova]
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
region_name = RegionOne
project_name = service
username = nova
password = skcc1234",
		}
	}
	file_line {'lock_path':
		path 	=> $path,
		match	=> '# lock_path',
		line	=> 'lock_path = /var/lib/neutron/tmp',
	}
	file_line {'verbose':
		path	=> $path,
		match	=> '# verbose',
		line	=> 'verbose = True',
	}
}

include neutron-conf


