exec{'abc':
  command => "sed -i '3s|!!!|def|g' test.txt",
  cwd => "/root/openstack-puppet/computenode/nova",
  path => "/bin",
}
