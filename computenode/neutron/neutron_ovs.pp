exec { 'integration_bridge':
        command => "sed -i '/^\[ovs\]/,/^\[agent\]/s/# integration_bridge/integration_bridge/' /etc/neutron/plugins/ml2/openvswitch_agent.ini",
        path    => ['/bin', '/sbin'],
}

exec { 'tunnel_bridge':
        command => "sed -i '/^\[ovs\]/,/^\[agent\]/s/# tunnel_bridge/tunnel_bridge/' /etc/neutron/plugins/ml2/openvswitch_agent.ini",
        path    => ['/bin', '/sbin'],
}

exec { 'local_ip':
        command => "sed -i '/^\[ovs\]/,/^\[agent\]/s/# local_ip =/local_ip = $ip_private/' /etc/neutron/plugins/ml2/openvswitch_agent.ini",
        path    => ['/bin', '/sbin'],
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
