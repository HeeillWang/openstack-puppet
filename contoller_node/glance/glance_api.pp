package {'openstack-glance':}
package {'python-glance':}
package {'python-glanceclient':}

class glance_api($path = '/etc/glance/glance-api.conf'){
	file_line {'connection':
		path	=> $path,
		match	=> '#connection=',
		line	=> 'connection = mysql://glance:GLANCE_DBPASS@controller/glance',
	}
	if file($path) =~ /auth_plugin/{}
	else {
        	file_line {'authtoken':
			path    => $path,
                	match   => '\[keystone_authtoken\]',
			line    => 
'[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = glance
password = GLANCE_PASS
',
        	}
	}

        file_line {'flavor':
                path    => $path,
                match   => '#flavor',
                line    => 'flavor = keystone',
        }

        file_line {'default_store':
                path    => $path,
                match   => '#default_store',
                line    => 'default_store = file',
        }

        file_line {'filesystem_store_datadir':
                path    => $path,
                match   => '#filesystem_store_datadir=',
                line    => 'filesystem_store_datadir = /var/lib/glance/images/',
	}
	
        file_line {'notification_driver':
                path    => $path,
                match   => '#notification_driver',
                line    => 'notification_driver = noop',
	}
}

include glance_api

Package['openstack-glance'] -> Package['python-glance'] -> Package['python-glanceclient'] -> Class['glance_api']
