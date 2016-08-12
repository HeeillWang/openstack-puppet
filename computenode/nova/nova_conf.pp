class nova_conf($path = "/etc/nova/nova.conf"){
   file_line{'rpc_backend':
      path => $path,
      line => "rpc_backend = rabbit",
      match => "#rpc_backend",
   }
   
   file_line{'rabbit_host':
      path => $path,
      line => "rabbit_host = controller",
      match => "#rabbit_host=",
   }
   
   file_line{'rabbit_userid':
      path => $path,
      line => "rabbit_userid = openstack",
      match => "#rabbit_userid",
   }

   file_line{'rabbit_password':
      path => $path,
      line => "rabbit_password = skcc1234",
      match => "#rabbit_password",
   }
}

include nova_conf
