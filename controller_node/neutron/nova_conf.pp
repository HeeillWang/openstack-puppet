if file("/etc/nova/nova.conf") =~ /username = neutron/{}
else{

	file_line { 'nova.conf':
        	path    => '/etc/nova/nova.conf',
        	match   => '\[neutron\]$',
        	line    =>
"[neutron]

url = http://controller:9696
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
region_name = RegionOne
project_name = service
username = neutron
password = $neutron_authpass"
	}
}


file_line {'service_metadata':
        path    => '/etc/nova/nova.conf',
        match   => '#service_metadata',
        line    => 'service_metadata_proxy = True',
}
if file('/etc/nova/nova.conf') =~ /#metadata_proxy_shared/{
file_line {'proxy_shared':
        path    => '/etc/nova/nova.conf',
        match   => '#metadata_proxy_shared_secret',
        line    => "metadata_proxy_shared_secret = $metadata_secret",
}
}
