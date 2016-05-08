APPLICATION_USER_HOME = ENV['APPLICATION_USER_HOME']

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

template '/etc/nginx/conf.d/unicorn.conf' do
  source 'templates/etc/nginx/conf.d/unicorn.conf.erb'
  variables(application_home_dir: APPLICATION_USER_HOME)
  owner 'root'
  group 'root'
  mode '0600'
end
