$pathes = '/etc/neutron/dhcp_agent.ini'

file_line {'interface_driver':
	path	=> $pathes,
	match	=> 'agent.linux.interface.BridgeInterfaceDriver',
	line	=> 'interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver',
}

file_line { 'dhcp_driver':
        path    => $pathes,
        match   => 'neutron.agent.linux.dhcp.Dnsmasq',
        line    => 'dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq',
}

file_line {'enable_isolated_metadata':
	path	=> $pathes,
	match	=> '# enable_isolated_metadata',
	line 	=> 'enable_isolated_metadata = True',
}

file_line {'dnsmasq_config_file':
	path	=> $pathes,
	match	=> 'dnsmasq_config_file'
	line	=> 'dnsmasq_config_file = /etc/neutron/dnsmasq-neutron.conf',
}

file {'/etc/neutron/dnsmasq-neutron.conf'
	path	=> '/etc/neutron/dnsmasq-neutron.conf',
	content	=> 'dhcp-option-force=26,1450'
}
