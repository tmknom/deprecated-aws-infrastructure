package 'http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm' do
  not_if 'rpm -q mysql-community-release'
end

%w(mysql mysql-devel mysql-server mysql-utilities).each do |pkg|
  package pkg do
    not_if 'test -e /usr/sbin/mysqld'
  end
end

directory '/var/log/mysql' do
  owner 'mysql'
  group 'mysql'
end

directory '/var/lib/mysql/binlog' do
  owner 'mysql'
  group 'mysql'
end

service 'mysqld' do
  action [:enable, :start]
end


define :execute_sql, sql: [] do
  params[:sql].each do |sql|
    execute sql do
      #not_if 'mysql -e "select * from mysql.user;"'
      command "mysql -e \"#{sql}\""
    end
  end
end

execute_sql 'drop test database' do
  sql ['DROP DATABASE IF EXISTS test;',
       'DELETE FROM mysql.db WHERE Db=\'test\' OR Db=\'test\\\\_%\'']
end

execute_sql 'delete user' do
  sql ['DELETE FROM mysql.user WHERE User=\'\';',
       'DELETE FROM mysql.user WHERE User=\'root\' AND Host NOT IN (\'localhost\', \'127.0.0.1\', \'::1\');']
end

execute_sql 'flush' do
  sql ['FLUSH PRIVILEGES;']
end
