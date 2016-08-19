Facter.add(:ipaddrs) do
	setcode do
		ipaddr_array = {}
		interfaces = Facter.value(:interfaces)
		interface_array = interfaces.split(',')
		interface_array.each do |interface|
			ipaddr = Facter.value("ipaddress_#{interface}")
			if ipaddr
				ipaddr_array[interface] = ipaddr
			end
		end
		
		ipaddr_array
	end
end
