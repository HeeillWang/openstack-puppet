$pathes = '/etc/neutron/l3_agent.ini'

file_line { 'interface_driver':
	path	=> $pathes,
	match	=> 'neutron.agent.linux.interface.BridgeInterfaceDriver',
	line	=> 'interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver',
}

file_line {'external_network_bridge':
	path	=> $pathes,
	match	=> '# external_network_bridge',
	line	=> 'external_network_bridge = br-public',
}

