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
password = skcc1234",
      match	=> "#auth_uri",
   }
   }

   file_line{'my_ip':
      path	=> $path,
      line	=> "my_ip = 10.0.2.15",
      match	=> "#my_ip",
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

   exec{'vnc_enabled':
      command => "sed -i '/\[vnc\]/,/\[workarounds\]/s/#enabled=true/enabled = true/g' nova.conf",
      cwd => "/etc/nova",
      path => "/bin",
   }

   file_line{'vncserver_listen':
      path	=> $path,
      line	=> "vncserver_listen = 0.0.0.0",
      match	=> "#vncserver_listen",
   }

   file_line{'server_proxyclient_address':
      path	=> $path,
      line	=> "vncserver_proxyclient_address = \$my_ip",
      match	=> "#vncserver_proxyclient_address",
   }

   file_line{'novncproxy_base_url':
      path	=> $path,
      line	=> "novncproxy_base_url = http://10.0.2.15:6080/vnc_auto.html",
      match	=> "#novncproxy_base_url",
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

   file_line{'verbose':
      path	=> $path,
      line	=> "verbose = True",
      match	=> "#verbose",
   }
}

include nova_conf
