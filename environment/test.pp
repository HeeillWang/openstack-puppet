

file { 'facterlib.sh':
	path	=> '/etc/profile.d/facterlib.sh',
	content => 'export FACTERLIB="/root/openstack-puppet/environment/custom_facts"',
}

exec { 'chmod':
	command	=> 'chmod a+x /etc/profile.d/facterlib.sh',
	path	=> '/bin',
}

File['facterlib.sh']->Exec['chmod']
