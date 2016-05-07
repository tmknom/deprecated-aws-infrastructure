remote_file '/etc/logrotate.d/nginx' do
  source 'files/etc/logrotate.d/nginx'
  owner 'root'
  group 'root'
  mode '0644'
end
