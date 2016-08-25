# keystone database password
Facter.add(:keystone_dbpass) do
	setcode do
		pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep "KEYSTONE_DBPASS ="')
		keystone_dbpass = pass[pass.index('=')+2,pass.length]
	end
end

# glance database password
Facter.add(:glance_dbpass) do
        setcode do
                pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep GLANCE_DBPASS')
                glance_dbpass = pass[pass.index('=')+2,pass.length]
        end
end

# nova database password
Facter.add(:nova_dbpass) do
        setcode do
                pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep NOVA_DBPASS')
                nova_dbpass = pass[pass.index('=')+2,pass.length]
        end
end

# neutron database password
Facter.add(:neutron_dbpass) do
        setcode do
                pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep NEUTRON_DBPASS')
                neutron_dbpass = pass[pass.index('=')+2,pass.length]
        end
end

# cinder database password
Facter.add(:cinder_dbpass) do
        setcode do
                pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep CINDER_DBPASS')
                cinder_dbpass = pass[pass.index('=')+2,pass.length]
        end
end

# swift database password
Facter.add(:swift_dbpass) do
        setcode do
                pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep SWIFT_DBPASS')
                swift_dbpass = pass[pass.index('=')+2,pass.length]
        end
end

# mysql database root password
Facter.add(:mysql_rootpass) do
        setcode do
                pass = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep MYSQL_ROOTPASS')
                mysql_rootpass = pass[pass.index('=')+2,pass.length]
        end
end
