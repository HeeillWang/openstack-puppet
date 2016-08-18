file {'ifcfg-br-public':
	path	=> '/etc/sysconfig/network-scripts/ifcfg-br-public',
	content	=> 
'DEVICE=br-public
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
IPADDR=10.0.2.15
NETMASK=255.255.255.0
NM_CONTROLLED=no
GATEWAY=10.0.0.0
DEVICETYPE=ovs
TYPE=OVSBridge',
}

file {'ifcfg-enp0s3':
	path	=> '/etc/sysconfig/network-scripts/ifcfg-enp0s3',
	content	=> 
'DEVICE=enp0s3
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
BONDING_OPTS="mode=4 miimon=100 downdelay=0 updelay=0 lacp_rate=fast xmit_hash_policy=1"
NM_CONTROLLED=no
DEVICETYPE=ovs
TYPE=OVSPort
OVS_BRIDGE=br-public',
}

file {'ifcfg-br-private':
	path    => '/etc/sysconfig/network-scripts/ifcfg-br-private',
	contetn	=> 
'DEVICE=br-private
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
IPADDR=192.168.56.0
NETMASK=255.255.255.0
NM_CONTROLLED=no
PEERDNS=yes
DNS1=8.8.8.8
DNS2=8.8.4.4
DEVICETYPE=ovs
TYPE=OVSBridge',
}

file {'ifcfg-enp0s8':
	path    => '/etc/sysconfig/network-scripts/ifcfg-enp0s8',
	content	=> 
'DEVICE=enp0s8
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
BONDING_OPTS="mode=4 miimon=100 downdelay=0 updelay=0 lacp_rate=fast xmit_hash_policy=1"
NM_CONTROLLED=no
DEVICETYPE=ovs
TYPE=OVSPort
OVS_BRIDGE=br-private
',
}
