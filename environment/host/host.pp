file_line{'hosts':
   path   => "/etc/hosts",
   match  => "controller",
   line   => "$ipaddr_private   controller",
}
if $num_compute != 0{
file_line{'hosts':
   path   => "/etc/hosts",
   match  => "compute",
   line   => "$ip_priv_com	compute",
}
}
