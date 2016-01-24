package 'redis' do
  options '--enablerepo=remi'
end

service 'redis' do
  action [:enable, :start]
end
