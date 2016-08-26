$pathes = '/etc/neutron/plugins/ml2/ml2_conf.ini'

file_line{ 'type_drivers':
	path	=> $pathes,
	match	=> '# type_drivers',
	line 	=> 'type_drivers = flat,vxlan',
}

file_line{ 'tenant_network_type':
        path    => $pathes,
        match   => '# tenant_network_type',
        line    => 'tenant_network_types = vxlan',
}

file_line{ 'mechanism_drivers':
        path    => $pathes,
        match   => '# mechanism_drivers',
        line    => 'mechanism_drivers = openvswitch,l2population',
}

file_line{ 'extension_drivers':
        path    => $pathes,
        match   => '# extension_drivers',
        line    => 'extension_drivers = port_security',
}

file_line{ 'flat_networks':
        path    => $pathes,
        match   => '# flat_networks',
        line    => 'flat_networks = public',
}
exec { 'vni_ranges':
	command => "sed -i '/\[ml2_type_vxlan\]/,/\[ml2_type_geneve\]/s/# vni_ranges =/vni_ranges = 1:1000/g' /etc/neutron/plugins/ml2/ml2_conf.ini",
	path	=> '/bin'
}
file_line{ 'enable_ipset':
        path    => $pathes,
        match   => '# enable_ipset',
        line    => 'enable_ipset = True',
}
