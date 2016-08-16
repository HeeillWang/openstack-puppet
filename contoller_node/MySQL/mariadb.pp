package {'mariadb':}
package {'mariadb-server':}
package {'MySQL-python':}

file{ 'mariadb_openstack.cnf':
	path	=> '/etc/my.cnf.d/mariadb_openstack.cnf',
	content	=>
'[mysqld]
bind-address = 0.0.0.0
default-storage-engine = innodb
inodb_file_per_table
collation-server = utf8_general_ci
init-connect-set-server = utf8
max_connections = 500
'
}

service {'mariadb':
	ensure	=> running,
	enable	=> true,
}
