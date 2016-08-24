Facter.add(:iface1_com) do
        setcode do
                iface = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep ifname1')
                result = iface[iface.index('=')+2, iface.length]
        end
end

Facter.add(:iface2_com) do
        setcode do
                iface = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep ifname2')
                result = iface[iface.index('=')+2, iface.length]
        end
end

Facter.add(:ip_pub_com) do
        setcode do
                ipaddr = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep ip_public')
                result = ipaddr[ipaddr.index('=')+2, ipaddr.length]
        end
end

Facter.add(:ip_priv_com) do
        setcode do
                ipaddr = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep ip_private')
                result = ipaddr[ipaddr.index('=')+2, ipaddr.length]
        end
end

Facter.add(:gateway_com) do
        setcode do
                gate = Facter::Core::Execution.exec('cat /root/openstack-puppet/answer.txt |grep gate_com')
                result = gate[gate.index('=')+2, gate.length]
        end
end

