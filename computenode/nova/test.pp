augeas { "sshd_config":
  context => "files/etc/ssh/sshd_config",
  changes => [
    "set #PermitRootLogin no",
  ],
}
