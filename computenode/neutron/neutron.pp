package {'openstack-neutron-openvswitch':}

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
	line	=> 'rabbit_password = RABBIT_PASS',
}

file_line{ 'auth_uri':
	path	=> '/etc/neutron/neutron.conf',
	match	=> 'auth_uri',
	line	=> 
'auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password',
}

file_line{ 'admin_tenant_name':
	path	=> '/etc/neutron/neutron.conf',
	match	=> '^admin_tenant_name',
	line	=> 
'project_domain_id = default
user_domain_id = default
project_name = service',
}

file_line{ 'admin_user':
	path	=> '/etc/neutron/neutron.conf',
	match	=> '^admin_user',
	line	=> 'username = neutron',
}

file_line{ 'admin_password':
	path	=> '/etc/neutron/neutron.conf',
	match	=> '^admin_password',
	line	=> 'password = NEUTRON_PASS',
}

exec { 'integration_bridge':
	command	=> "sed -i '8s/# //' /etc/neutron/plugins/ml2/openvswitch_agent.ini",
	path	=> ['/bin', '/sbin'],
}

exec { 'tunnel_bridge':
	command	=> "sed -i '13s/# //' /etc/neutron/plugins/ml2/openvswitch_agent.ini",
	path	=> ['/bin', '/sbin'],
}

$ipaddr = "local_ip = $ipaddress_enp0s3"
file_line{ 'local_ip':
	path	=> '/etc/neutron/plugins/ml2/openvswitch_agent.ini',
	match	=> '# local_ip =$',
	line	=> $ipaddr,
}

file_line{'bridge_mappings':
	path	=> '/etc/neutron/plugins/ml2/openvswitch_agent.ini',
	match	=> '# bridge_mappings =$',
	line	=> 'bridge_mappings = public:br-public,private:br-private',
}

file_line{ 'tunnel_tpyes':
	path	=> '/etc/neutron/plugins/ml2/openvswitch_agent.ini',
	match	=> '# tunnel_types =$',
	line	=> 'tunnel_types = vxlan',
}

file_line{ 'l2_population':
	path	=> '/etc/neutron/plugins/ml2/openvswitch_agent.ini',
	match	=> '# l2_population',
	line	=> 'l2_population = True',
}

file_line{ 'prevent_arp_spoofing':
	path	=> '/etc/neutron/plugins/ml2/openvswitch_agent.ini',
	match	=> '# prevent_arp_spoofing',
	line	=> 'prevent_arp_spoofing = True',
}

file_line{ 'firewall_driver':
	path	=> '/etc/neutron/plugins/ml2/openvswitch_agent.ini',
	match	=> '# firewall_driver',
	line	=> 'firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver',
}

file_line{ 'nova.conf':
	path	=> '/etc/nova/nova.conf',
	match	=> '#uri=',
	line	=> 
'url = http://controller:9696
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
region_name = RegionOne
project_name = service
username = neutron
password = NEUTRON_PASS'
}

service {'neutron-openvswitch-agent':
	ensure => running,
	enable => true,
}
