class cinder-package(){
   package{'openstack-cinder':}
   package{'python-cinderclient':}
   package{'lvm2':}
   package{'targetcli':}
   package{'python-oslo-policy':}   
}

include cinder-package

service{'lvm2-lvmetad':
   ensure   => running,
   enable   => true, 
}

Class['cinder-package'] -> Service['lvm2-lvmetad']
