package {'chrony':}

service {'chronyd':
	ensure	=> running,
	enable	=> true,
}


if $hostname != controller{
	file_line {'iburst':
		path	=> '/etc/chrony.conf',
		match	=> 'iburst',
		line	=> 'server controller iburst',
		multiple => true,
	}


	Package['chrony'] -> File_line['iburst'] -> Service['chronyd']
}
else {
	file_line {'iburst':
		path	=> '/etc/chrony.conf',
		match	=> 'iburst',
		line	=> 'server time.bora.net iburst',
		multiple => true,
	}
	file_line {'allow':
		path	=> '/etc/chrony.conf',
		match	=> 'allow',
		line	=> "allow $priv_subnet",
	}
	Package['chrony'] -> File_line[iburst] -> File_line['allow'] -> Service['chronyd']
}


