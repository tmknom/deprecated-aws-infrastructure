# User settings
SWAP_SIZE_MB = 1024

execute 'allocate swap' do
  SWAP_FILE = '/swapfile'
  not_if "swapon -s | grep #{SWAP_FILE}"
  command <<-EOL
      fallocate -l #{SWAP_SIZE_MB}m #{SWAP_FILE}
      chmod 600 #{SWAP_FILE}
      mkswap #{SWAP_FILE}
      swapon #{SWAP_FILE}
      echo "#{SWAP_FILE} swap swap defaults 0 0" >> /etc/fstab
  EOL
end
