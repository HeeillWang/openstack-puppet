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

#Nova auth password
Facter.add(:nova_authpass) do
	setcode do
		pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep nova_authpass')
		nova_authpass = pass[pass.index('=')+2,pass.length]
	end
end

#Glance auth password
Facter.add(:glance_authpass) do
	setcode do
		pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep glance_authpass')
		glance_authpass = pass[pass.index('=')+2,pass.length]
	end
end

#Neutron auth password
Facter.add(:neutron_authpass) do
	setcode do
		pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep neutron_authpass')
		neutron_authpass = pass[pass.index('=')+2,pass.length]
	end
end

#Admin auth password
Facter.add(:admin_authpass) do
	setcode do
		pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep admin_authpass')
		admin_authpass = pass[pass.index('=')+2,pass.length]
	end
end
