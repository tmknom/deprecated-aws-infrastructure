remote_file '/etc/logrotate.d/app' do
  source 'files/etc/logrotate.d/app'
  owner 'root'
  group 'root'
  mode '0644'
end
