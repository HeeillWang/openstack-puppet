$i = split($interfaces,',')
$fname1 = "/etc/sysconfig/network-scripts/ifcfg-${i[1]}"
$fname2 = "/etc/sysconfig/network-scripts/ifcfg-${i[2]}"
file { $fname1:
	content	=>
"DEVICE=${i[1]}
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
	content	=>
"DEVICE=${i[2]}
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
