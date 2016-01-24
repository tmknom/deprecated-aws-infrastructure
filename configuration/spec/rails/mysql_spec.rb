require 'spec_helper'

describe 'mysql' do
  describe 'mysqld' do
    describe command('mysqld --version') do
      its(:stdout) { should match /^mysqld\s+Ver\s+5\.6/ }
    end

    describe file('/var/log/mysql') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'mysql' }
      it { should be_grouped_into 'mysql' }
    end

    describe file('/var/lib/mysql/binlog') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'mysql' }
      it { should be_grouped_into 'mysql' }
    end

    describe service('mysqld') do
      it { should be_enabled }
      it { should be_running }
    end
  end

  describe 'database' do
    describe sql_command('show databases;') do
      its(:stdout) { should_not match /test/ }
    end

    describe sql_command('select count(*) from mysql.db;') do
      its(:stdout) { should match /0/ }
    end

    describe sql_command('select count(user) from mysql.user;') do
      its(:stdout) { should match /3/ }
    end
  end
end
