$fname1 = "/etc/sysconfig/network-scripts/ifcfg-$ifname1"
$fname2 = "/etc/sysconfig/network-scripts/ifcfg-$ifname2"

file { $fname1:
	path	=> $fname1,
	content	=>
"DEVICE=ifname1
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
BOUNDING_OPTS='mode=4 miimon=100 downdelay=0 lacp_rate=fast xmit_hash_policy=1'
NM_CONTROLLED=no
DEVICETYPE=ovs
TYPE=OVSPort
OVS_BRIDGE=br-public
"
}

file { $fname2:
	path	=> fname2,
	content	=>
"DEVICE=$ifname2
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
BOUNDING_OPTS='mode=4 miimon=100 downdelay=0 lacp_rate=fast xmit_hash_policy=1'
NM_CONTROLLED=no
DEVICETYPE=ovs
TYPE=OVSPort
OVS_BRIDGE=br-private
"
}

file {'ifcfg-br-public':
        path    => '/etc/sysconfig/network-scripts/ifcfg-br-public',
        content =>
"DEVICE=br-public
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
IPADDR=$ip_pub_com
NETMASK=255.255.255.0
NM_CONTROLLED=no
GATEWAY=$gate_com
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
IPADDR=$ip_priv_com
NETMASK=255.255.255.0
NM_CONTROLLED=no
PEERDNS=yes
DNS1=8.8.8.8
DNS2=8.8.4.4
DEVICETYPE=ovs
TYPE=OVSBridge",
}

