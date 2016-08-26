Facter.add(:metadata_secret) do
        setcode do
                meta = Facter::Core::Execution.exec('cat /root/metadata_secret.txt')
        end
end

