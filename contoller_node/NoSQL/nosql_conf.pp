class nosql($path = '/etc/mongod.conf'){
   file_line{'bind_ip':
      path      => $path,
      line      => "bind_ip = 10.0.2.15",
      match     => "bind_ip",
   }

   file_line{'smallfiles':
      path      => $path,
      line      => "smallfiles = true",
      match     => "#smallfiles",
   }

}

include nosql
