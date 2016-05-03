package 'http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm' do
  not_if 'rpm -q mysql-community-release'
end

%w(mysql mysql-devel).each do |pkg|
  package pkg
end
