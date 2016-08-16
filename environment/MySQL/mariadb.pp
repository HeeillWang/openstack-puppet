package {'mariadb':}
package {'mariadb-server':}
package {'MySQL-python':}

file{ 'mariadb_openstack.cnf':
	path	=> '/etc/my.cnf.d/mariadb_openstack.cnf',
	content	=>
"[mysqld]
bind-address = 10.0.2.15
default-storage-engine = innodb
innodb_file_per_table
collation-server = utf8_general_ci
init-connect = 'SET NAMES utf8'
character-set-server = utf8
"
}

service {'mariadb':
	ensure	=> running,
	enable	=> true,
}

Package['mariadb'] -> Package['mariadb-server'] -> Package['MySQL-python'] -> File['mariadb_openstack.cnf'] -> Service['mariadb']
