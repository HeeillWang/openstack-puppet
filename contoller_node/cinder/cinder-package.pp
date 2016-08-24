class cinder-package(){
   package{'openstack-cinder':}
   package{'python-cinderclient':}
}

include cinder-package
