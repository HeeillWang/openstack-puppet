$pathes = '/etc/neutron/metadata_agent.ini'

file_line { 'auth_uri':
	path	=> $pathes,
	match	=> 'auth_url',
	line	=> 
'auth_uri = http://controller:5000
auth_url = http://controller:35357',
}

file_line { 'auth_plugin':
        path    => $pathes,
        match   => 'auth_region',
        line    => 
'auth_region = RegionOne
auth_plugin = password',
}

file_line { 'project_domain_id':
        path    => $pathes,
        match   => 'admin_tenant_name',
        line    => 'project_domain_id = default',
}

file_line { 'user_domain_id':
        path    => $pathes,
        match   => 'admin_user',
        line    => 
'user_domain_id = default
project_name = service',
}

file_line { 'username':
        path    => $pathes,
        match   => 'admin_password',
        line    => 
'username = neutron
password = NEUTRON_PASS',
}

file_line { 'metadata_ip':
        path    => $pathes,
        match   => '# nova_metadata_ip',
        line    => 'nova_metadeta_ip = controller',
}


file_line { 'metadata_proxy':
        path    => $pathes,
        match   => '# metadata_proxy_shared_secret',
        line    => 'metadata_proxy_shared_secret = METADATA_SECRET',
}

file_line { 'nova.conf':
	path	=> '/etc/nova/nova.conf',
	match	=> '\[neutron\]',
	line	=>
'[neutron]

url = http://controller:9696
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
region_name = RegionOne
project_name = service
username = neutron
password = NEUTRON_PASS'
}

file_line {'service_metadata':
	path	=> '/etc/nova/nova.conf',
	match	=> '#service_metadata',
	line	=> 'service_metadata_proxy = True',
}

file_line {'proxy_shared':
	path	=> '/etc/nova/nova.conf',
	match	=> '#metadata_proxy_shared_secret',
	line	=> 'metadata_proxy_shared_secret = METADATA_SECRET',
}

