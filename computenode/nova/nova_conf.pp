class nova_conf($path = "/etc/nova/nova.conf"){
   file_line{'rpc_backend':
      path	=> $path,
      line	=> "rpc_backend = rabbit",
      match	=> "#rpc_backend",
   }
   
   file_line{'rabbit_host':
      path	=> $path,
      line	=> "rabbit_host = controller",
      match	=> "#rabbit_host=",
   }
   
   file_line{'rabbit_userid':
      path	=> $path,
      line	=> "rabbit_userid = openstack",
      match	=> "#rabbit_userid",
   }

   file_line{'rabbit_password':
      path	=> $path,
      line	=> "rabbit_password = skcc1234",
      match	=> "#rabbit_password",
   }
 
   exec{'auth_strategy':
      command => "sed -i '506s|#||g' nova.conf",
      cwd => "/etc/nova",
      path => "/bin",
   }

   if file("/etc/nova/nova.conf") =~ /\#auth_uri/{
   file_line{'auth_uri':
      path	=> $path,
      line	=>
"auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = nova
password = skcc1234",
      match	=> "#auth_uri",
   }
   }

}

include nova_conf
