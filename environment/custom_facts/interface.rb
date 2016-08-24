Facter.add(:iface1) do
        setcode do
                iface = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep iface1')
                result = ifcae[iface.index('=')+2, iface.length]
        end
end

Facter.add(:iface2) do
        setcode do
                iface = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep iface2')
                result = ifcae[iface.index('=')+2, iface.length]
        end
end

