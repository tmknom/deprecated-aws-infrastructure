remote_file '/etc/monit.d/nginx.conf' do
  source 'files/etc/monit.d/nginx.conf'
  owner 'root'
  group 'root'
  mode '0600'
end
