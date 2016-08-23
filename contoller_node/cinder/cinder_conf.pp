class cinder_conf($path = "/etc/cinder/cinder.conf"){
   file_line{'database_connection':
      path	=> $path,
      line	=> "connection = mysql://cinder:CINDER_DBPASS@controller/cinder",
      match	=> "#connection = ",
   }

   #target is on line:2294 
   exec{'rpc_backend':
      command => "sed -i '2280,2310s/#rpc_backend = rabbit/rpc_backend = rabbit/g' cinder.conf",
      cwd => "/etc/cinder",
      path => "/bin",
   }

   #target is on line:3165 
   exec{'rabbit_host':
      command => "sed -i '3100,3200s/#rabbit_host = localhost/rabbit_host = controller/g' cinder.conf",
      cwd => "/etc/cinder",
      path => "/bin",
   }

   #target is on line:3181
   exec{'rabbit_userid':
      command => "sed -i '3150,3250s/#rabbit_userid = guest/rabbit_userid = openstack/g' cinder.conf",
      cwd => "/etc/cinder",
      path => "/bin",
   }

   #target is on line:3185
   exec{'rabbit_password':
      command => "sed -i '3150,3250s/#rabbit_password = guest/rabbit_password = RABBIT_PASS/g' cinder.conf",
      cwd => "/etc/cinder",
      path => "/bin",
   }

   file_line{'auth_strategy':
      path	=> $path,
      line	=> "auth_strategy = keystone",
      match	=> "auth_strategy =",
   }

   #add lines only one time
   if file("/etc/cinder/cinder.conf") =~ /\#auth_uri/{
      file_line{'keystone_authtoken':
         path	=> $path,
         line	=>
"auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = cinder
password = skcc1234",
         match	=> "#auth_uri",
      }
   }

   file_line{'my_ip':
      path	=> $path,
      line	=> "my_ip = 10.0.2.15",
      match	=> "my_ip = ",
   }

   file_line{'lock_path':
      path	=> $path,
      line	=> "lock_path = /var/lib/cinder/tmp",
      match	=> "lock_path = ",
   }
}

include cinder_conf
