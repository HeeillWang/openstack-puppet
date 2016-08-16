package {'rabbitmq-server':}

service {'rabbitmq-server':
	ensure	=> running,
	enable	=> true,
}
