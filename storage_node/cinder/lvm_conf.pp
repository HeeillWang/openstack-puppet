#target is on line:130
#exec{'rpc_backend':
#   command => "sed -i '130s/# filter = \[ \"a\|.\*\/\|\" \]/ filter = \[ \"a\/sdb1\/\"\, \"a\/sda2\/\"\, \"r\/.\*\/\" \]/g' lvm.conf",
#   cwd => "/etc/lvm/",
#   path => "/bin",
#}

file_line{'filter':
   after   => "# Accept every block device:",
   match_for_absence => true,
   path    => "/etc/lvm/lvm.conf",
   line    => 'filter = [ "a/sda/", "a/sdb/", "r/.*/"]',
}
