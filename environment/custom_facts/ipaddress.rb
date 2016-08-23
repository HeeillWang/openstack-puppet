Facter.add(:ipaddr_public) do
	setcode do
		ipaddr = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep ipaddr_public')
		result = ipaddr[ipaddr.index('=')+2, ipaddr.length]
	end
end

Facter.add(:ipaddr_private) do
        setcode do
                ipaddr = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep ipaddr_private')
                result = ipaddr[ipaddr.index('=')+2, ipaddr.length]
        end
end

Facter.add(:gateway) do
        setcode do
                gate = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep gateway')
                result = gate[gate.index('=')+2, gate.length]
        end
end

