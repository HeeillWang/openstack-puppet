package {'rabbitmq-server':}

service {'rabbitmq-server':
	ensure	=> running,
	enable	=> true,
}

Package['rabbitmq-server'] -> Service['rabbitmq-server']
