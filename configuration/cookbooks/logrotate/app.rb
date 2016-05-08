APPLICATION_USER_NAME = ENV['APPLICATION_USER_NAME']

template '/etc/logrotate.d/app' do
  source 'templates/etc/logrotate.d/app.erb'
  variables(application_user_name: APPLICATION_USER_NAME)
  owner 'root'
  group 'root'
  mode '0644'
end
