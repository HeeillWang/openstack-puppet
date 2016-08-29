class control_nova_conf($path = "/etc/nova/nova.conf"){
   #for change option(when the option is not commented with '#')
   exec{'database_connection_change':
      command => "sed -i '1719,1770s/connection=.*/connection=mysql:\/\/nova:$nova_dbpass@controller\/nova/g' nova.conf",
      cwd => "/etc/nova",
      path => "/bin",
   }

   #for inital excute(when the option is commented with '#')
   exec{'database_connection':
      command => "sed -i '1719,1770s/#connection=.*/connection=mysql:\/\/nova:$nova_dbpass@controller\/nova/g' nova.conf",
      cwd => "/etc/nova",
      path => "/bin",
   }

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
      line	=> "rabbit_password = $rabbit_pass",
      match	=> "#rabbit_password",
   }
 
   exec{'auth_strategy':
      command => "sed -i '/\[DEFAULT\]/,/\[api_database\]/s/#auth_strategy=keystone/auth_strategy = keystone/g' nova.conf",
      cwd => "/etc/nova",
      path => "/bin",
   }

   #add lines only one time
   if file("/etc/nova/nova.conf") =~ /\#auth_uri/{
      file_line{'keystone_authtoken':
         path	=> $path,
         line	=>
"auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = nova
password = $nova_authpass",
         match	=> "#auth_uri",
      }
   }

   file_line{'my_ip':
      path	=> $path,
      line	=> "my_ip=$ip_private",
      match	=> "my_ip=",
   }

   file_line{'network_api_class':
      path	=> $path,
      line	=> "network_api_class = nova.network.neutronv2.api.API",
      match	=> "#network_api_class",
   }

   file_line{'security_group_api':
      path	=> $path,
      line	=> "security_group_api = neutron",
      match	=> "#security_group_api",
   }

   file_line{'linuxnet_interface_driver':
      path	=> $path,
      line	=> "linuxnet_interface_driver = nova.network.linux_net.NeutronLinuxBridgeInterfaceDriver",
      match	=> "#linuxnet_interface_driver",
   }

   file_line{'firewall_driver':
      path	=> $path,
      line	=> "firewall_driver = nova.virt.firewall.NoopFirewallDriver",
      match	=> "#firewall_driver",
   }

   file_line{'vncserver_listen':
      path	=> $path,
      line	=> "vncserver_listen=\$my_ip",
      match	=> "vncserver_listen=",
   }

   file_line{'server_proxyclient_address':
      path	=> $path,
      line	=> "vncserver_proxyclient_address = \$my_ip",
      match	=> "#vncserver_proxyclient_address",
   }

   exec{'glance_host':
      command => "sed -i '/\[glance\]/,/\[guestfs\]/s/#host=\$my_ip/host = controller/g' nova.conf",
      cwd => "/etc/nova",
      path => "/bin",
   }

   file_line{'lock_path':
      path	=> $path,
      line	=> "lock_path = /var/lib/nova/tmp",
      match	=> "#lock_path",
   }

   file_line{'enabled_apis':
      path	=> $path,
      line	=> "enabled_apis = osapi_compute,metadata",
      match	=> "#enabled_apis",
   }


}

include control_nova_conf
