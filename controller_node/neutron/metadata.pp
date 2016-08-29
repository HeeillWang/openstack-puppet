$pathes = '/etc/neutron/metadata_agent.ini'
if file($pathes) =~ /auth_url = http:\/\/controller:35357/{}
else{
file_line { 'auth_uri':
	path	=> $pathes,
	match	=> 'auth_url',
	line	=> 
'auth_uri = http://controller:5000
auth_url = http://controller:35357',
}
}

if file($pathes) =~ /auth_plugin = password/{}
else{
file_line { 'auth_plugin':
        path    => $pathes,
        match   => 'auth_region',
        line    => 
'auth_region = RegionOne
auth_plugin = password',
}
}

file_line { 'project_domain_id':
        path    => $pathes,
        match   => 'admin_tenant_name',
        line    => 'project_domain_id = default',
}

if file($pathes) =~ /admin_user/{
file_line { 'user_domain_id':
        path    => $pathes,
        match   => 'admin_user',
        line    => 
'user_domain_id = default
project_name = service',
}
}

if file($pathes) =~ /admin_password/{
file_line { 'username':
        path    => $pathes,
        match   => 'admin_password',
        line    => 
"username = neutron
password = $neutron_authpass",
}
}

file_line { 'metadata_ip':
        path    => $pathes,
        match   => '# nova_metadata_ip',
        line    => 'nova_metadata_ip = controller',
}
if file($pathes) =~ /^metadata_proxy_shared_secret/{}
else {
file_line { 'metadata_proxy':
        path    => $pathes,
        match   => '# metadata_proxy_shared_secret',
        line    => "metadata_proxy_shared_secret = $metadata_secret",
}
}
