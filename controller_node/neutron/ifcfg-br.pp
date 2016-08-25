file {'ifcfg-br-public':
	path	=> '/etc/sysconfig/network-scripts/ifcfg-br-public',
	content	=> 
"DEVICE=br-public
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
IPADDR=$ipaddr_public
NETMASK=255.255.255.0
NM_CONTROLLED=no
GATEWAY=$gateway
DEVICETYPE=ovs
TYPE=OVSBridge",
}

file {"ifcfg-$iface1":
	path	=> "/etc/sysconfig/network-scripts/ifcfg-$iface1",
	content	=> 
"DEVICE=$iface1
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
BONDING_OPTS='mode=4 miimon=100 downdelay=0 updelay=0 lacp_rate=fast xmit_hash_policy=1'
NM_CONTROLLED=no
DEVICETYPE=ovs
TYPE=OVSPort
OVS_BRIDGE=br-public",
}

file {'ifcfg-br-private':
	path    => '/etc/sysconfig/network-scripts/ifcfg-br-private',
	content	=> 
"DEVICE=br-private
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
IPADDR=$ipaddr_private
NETMASK=255.255.255.0
NM_CONTROLLED=no
PEERDNS=yes
DNS1=8.8.8.8
DNS2=8.8.4.4
DEVICETYPE=ovs
TYPE=OVSBridge",
}

file {"ifcfg-$iface2":
	path    => "/etc/sysconfig/network-scripts/ifcfg-$iface2",
	content	=> 
"DEVICE=$iface2
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
BONDING_OPTS='mode=4 miimon=100 downdelay=0 updelay=0 lacp_rate=fast xmit_hash_policy=1'
NM_CONTROLLED=no
DEVICETYPE=ovs
TYPE=OVSPort
OVS_BRIDGE=br-private
",
}
