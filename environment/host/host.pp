file_line{'hosts':
   path   => "/etc/hosts",
   match  => "controller",
   line   => "$ip_private   controller",
}
if $num_compute != 0{
file_line{'hosts_compute':
   path   => "/etc/hosts",
   match  => "compute",
   line   => "$ip_private_com	compute",
}
}
