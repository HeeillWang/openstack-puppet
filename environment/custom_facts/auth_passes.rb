#Rabbitmq  password
Facter.add(:rabbit_pass) do
	setcode do
		pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep rabbit_pass')
		rabbit_pass = pass[pass.index('=')+2,pass.length]
	end
end

#Cinder auth password
Facter.add(:cinder_authpass) do
	setcode do
		pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep cinder_authpass')
		cinder_authpass = pass[pass.index('=')+2,pass.length]
	end
end
