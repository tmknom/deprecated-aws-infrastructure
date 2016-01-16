COMMAND_LOG_DIR = '/var/log/command'

remote_file '/etc/profile.d/command_log.sh' do
  source 'files/etc/profile.d/command_log.sh'
  owner 'root'
  group 'root'
  mode '0644'
end

execute 'create command log dir' do
  not_if "test -e #{COMMAND_LOG_DIR}"
  command <<-EOL
    mkdir -p #{COMMAND_LOG_DIR}
    chmod 1777 #{COMMAND_LOG_DIR}
    chown root:root #{COMMAND_LOG_DIR}
  EOL
end
