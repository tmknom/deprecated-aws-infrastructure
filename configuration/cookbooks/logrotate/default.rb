remote_file '/etc/logrotate.conf' do
  source 'files/etc/logrotate.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

remote_file '/etc/logrotate.d/syslog' do
  source 'files/etc/logrotate.d/syslog'
  owner 'root'
  group 'root'
  mode '0644'
end

remote_file '/etc/logrotate.d/monit' do
  source 'files/etc/logrotate.d/monit'
  owner 'root'
  group 'root'
  mode '0644'
end
