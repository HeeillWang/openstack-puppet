class keystone_conf($token = file('/root/rand_hex.txt'),
$path = '/etc/keystone/keystone.conf'){
    file_line{'admin_token':
       path   => $path,
       line   => "admin_token = $token",
       match  => "#admin_token",
    }

    file_line{'connection':
       path   => $path,
       line   => "connection = mysql://keystone:skcc1234@controller/keystone",
       match  => "#connection =",
    }

    file_line{'servers':
       path   => $path,
       line   => "servers = localhost:11211",
       match  => "#servers",
    }

    file_line{'provider':
       path   => $path,
       line   => "provider = uuid",
       match  => "#provider",
    }
    
    #change 'driver' option on [token] tab
    exec{'token_driver':
       command   => "sed -i '/\[token\]/,/\[tokenless_auth\]/s/#driver = sql/driver = memcache/g' keystone.conf",
       cwd       =>"/etc/keystone",
       path      => "/bin",
    }
    
    #change 'driver' option on [revoke] tab
    exec{'revoke_driver':
       command   => "sed -i '/\[revoke\]/,/\[role\]/s/#driver = sql/driver = sql/g' keystone.conf",
       cwd       =>"/etc/keystone",
       path      => "/bin",
    }
}

include keystone_conf
