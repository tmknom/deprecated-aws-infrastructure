package 'nginx' do
  action :install
end

service 'nginx' do
  action [:enable, :start]
end

remote_file '/etc/nginx/nginx.conf' do
  source 'files/etc/nginx/nginx.conf'
  owner 'root'
  group 'root'
  mode '0600'
end

remote_file '/etc/nginx/conf.d/unicorn.conf' do
  source 'files/etc/nginx/conf.d/unicorn.conf'
  owner 'root'
  group 'root'
  mode '0600'
end
