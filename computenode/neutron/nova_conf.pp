if file("/etc/nova/nova.conf") =~ /\#uri=/{
        file_line{ 'nova.conf':
                path    => '/etc/nova/nova.conf',
                match   => '#url=',
                line    =>
"url = http://controller:9696
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

