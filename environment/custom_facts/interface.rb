Facter.add(:iface1) do
        setcode do
                iface = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep -w iface1')
                result = iface[iface.index('=')+2, iface.length]
        end
end

Facter.add(:iface2) do
        setcode do
                iface = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep -w iface2')
                result = iface[iface.index('=')+2, iface.length]
        end
end
