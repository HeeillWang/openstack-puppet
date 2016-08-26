$fname1 = "/etc/sysconfig/network-scripts/ifcfg-$iface1_com"
$fname2 = "/etc/sysconfig/network-scripts/ifcfg-$iface2_com"

file { "ifcfg-$iface1_com":
	path	=> $fname1,
	content	=>
"DEVICE=$iface1_com
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
BONDING_OPTS='mode=4 miimon=100 downdelay=0 updelay=0 lacp_rate=fast xmit_hash_policy=1'
NM_CONTROLLED=no
DEVICETYPE=ovs
TYPE=OVSPort
OVS_BRIDGE=br-public"
}

file { "ifcfg-$iface2_com":
	path	=> $fname2,
	content	=>
"DEVICE=$iface2_com
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
BONDING_OPTS='mode=4 miimon=100 downdelay=0 updelay=0 lacp_rate=fast xmit_hash_policy=1'
NM_CONTROLLED=no
DEVICETYPE=ovs
TYPE=OVSPort
OVS_BRIDGE=br-private"
}

file {'ifcfg-br-public':
        path    => '/etc/sysconfig/network-scripts/ifcfg-br-public',
        content =>
"DEVICE=br-public
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
IPADDR=$ip_public_com
NETMASK=255.255.255.0
NM_CONTROLLED=no
GATEWAY=$gateway_com
DEVICETYPE=ovs
TYPE=OVSBridge",
}

file {'ifcfg-br-private':
        path    => '/etc/sysconfig/network-scripts/ifcfg-br-private',
        content =>
"DEVICE=br-private
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
IPADDR=$ip_private_com
NETMASK=255.255.255.0
NM_CONTROLLED=no
PEERDNS=yes
DNS1=8.8.8.8
DNS2=8.8.4.4
DEVICETYPE=ovs
TYPE=OVSBridge",
}

