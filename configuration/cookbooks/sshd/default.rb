# User settings
SSH_PORT = ENV['SSH_PORT']

# Constant definition
SSH_CONFIG = '/etc/ssh/sshd_config'

execute 'backup sshd config' do
  not_if "test -e #{SSH_CONFIG}.org"
  command "cp -p #{SSH_CONFIG} #{SSH_CONFIG}.org"
end

execute 'change ssh port' do
  not_if "cat #{SSH_CONFIG} | grep '^Port #{SSH_PORT}'"
  command "sed -i 's/^#Port\s\\+22/Port #{SSH_PORT}/' #{SSH_CONFIG}"
end

execute 'disable root login' do
  not_if "cat #{SSH_CONFIG} | grep '^PermitRootLogin no'"
  command "sed -i 's/^#PermitRootLogin\s\\+yes/PermitRootLogin no/' #{SSH_CONFIG}"
end

execute 'disable password authentication' do
  not_if "cat #{SSH_CONFIG} | grep '^PasswordAuthentication no'"
  command "sed -i 's/^PasswordAuthentication\s\\+yes/PasswordAuthentication no/' #{SSH_CONFIG}"
end

execute 'enable public key authentication' do
  not_if "cat #{SSH_CONFIG} | grep '^PubkeyAuthentication yes'"
  command "sed -i 's/^#PubkeyAuthentication\s\\+yes/PubkeyAuthentication yes/' #{SSH_CONFIG}"
end

service 'sshd' do
  action :reload
end
