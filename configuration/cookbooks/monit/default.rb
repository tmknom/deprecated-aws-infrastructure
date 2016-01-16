package 'monit' do
  action :install
end

remote_file '/etc/init/monit.conf' do
  # https://github.com/arnaudsj/monit/blob/master/contrib/monit.upstart
  source 'files/etc/init/monit.conf'
  owner 'root'
  group 'root'
  mode '0600'
end
