remote_file '/etc/logrotate.conf' do
  source 'files/etc/logrotate.conf'
  owner 'root'
  group 'root'
  mode '0644'
end
