exec { 'integration_bridge':
	command	=> "sed -i '0,/# integration_bridge/s/# integration_bridge/integration_bridge/' /etc/neutron/plugins/ml2/openvswitch_agent.ini",
	path	=> ['/bin', '/sbin'],
}

exec { 'tunnel_bridge':
	command	=> "sed -i '0,/# tunnel_bridge/s/# tunnel_bridge/tunnel_bridge/' /etc/neutron/plugins/ml2/openvswitch_agent.ini",
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

if file("/etc/nova/nova.conf") =~ /\#uri=/{
	file_line{ 'nova.conf':
		path	=> '/etc/nova/nova.conf',
		match	=> '#url=',
		line	=> 
'url = http://controller:9696
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
region_name = RegionOne
project_name = service
username = neutron
password = skcc1234'
	}
}

service {'neutron-openvswitch-agent':
	ensure => running,
	enable => true,
}
