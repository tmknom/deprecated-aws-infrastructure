# -*- encoding:utf-8 -*-
from fabric.api import *

@task
def setup():
  execute_setup()

def execute_setup():
  rpm_repository()
  yum()
  create_swap()
  rbenv()
  ruby()
  mysql()
  init_db()
  create_db()
  redis()

def rpm_repository():
  sudo('yum install -y epel-release')
  sudo('rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi')
  sudo('rpm -iv http://rpms.famillecollet.com/enterprise/remi-release-6.rpm', warn_only=True)

def yum():
  sudo('yum update -y')
  sudo('yum install -y wget jq zip unzip tree telnet sysstat strace')
  sudo('yum install -y gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel')
  sudo('yum install -y git')
  sudo('yum --enablerepo=epel install -y nodejs')

def rbenv():
  sudo('git clone https://github.com/rbenv/rbenv.git /opt/.rbenv')
  sudo('git clone https://github.com/rbenv/ruby-build.git /opt/.rbenv/plugins/ruby-build')
  sudo('echo \'export RBENV_ROOT="/opt/.rbenv"\' >> /etc/profile.d/rbenv.sh')
  sudo('echo \'export PATH="/opt/.rbenv/bin:$PATH"\' >> /etc/profile.d/rbenv.sh')
  sudo('echo \'eval "$(rbenv init -)"\' >> /etc/profile.d/rbenv.sh')
  sudo('source /etc/profile.d/rbenv.sh')

def ruby():
  RUBY_VERSION = '2.3.0'
  sudo('rbenv install %s' % (RUBY_VERSION))
  sudo('rbenv global %s' % (RUBY_VERSION))
  sudo('gem update --system --no-document')
  sudo('gem update --no-document')
  sudo('gem install bundler --no-document')

def mysql():
  sudo('rpm -i http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm')
  sudo('yum install -y mysql mysql-devel mysql-server mysql-utilities')
  sudo('mkdir /var/log/mysql')
  sudo('chown mysql:mysql /var/log/mysql')
  sudo('mkdir /var/lib/mysql/binlog')
  sudo('chown mysql:mysql /var/lib/mysql/binlog')
  sudo('chkconfig mysqld on')
  sudo('service mysqld start')

def init_db():
  sudo('mysql -e "DROP DATABASE IF EXISTS test;"')
  sudo('mysql -e "DELETE FROM mysql.db WHERE Db=\'test\' OR Db=\'test\\\\_%\'"')
  sudo('mysql -e "DELETE FROM mysql.user WHERE User=\'\';"')
  sudo('mysql -e "DELETE FROM mysql.user WHERE User=\'root\' AND Host NOT IN (\'localhost\', \'127.0.0.1\', \'::1\');"')
  sudo('mysql -e "FLUSH PRIVILEGES;"')

def create_db():
  sudo('mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO development_user@localhost IDENTIFIED BY \'development_password\' WITH GRANT OPTION;"')
  sudo('mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO test_user@localhost IDENTIFIED BY \'test_password\' WITH GRANT OPTION;"')
  sudo('mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO production_user@localhost IDENTIFIED BY \'production_password\' WITH GRANT OPTION;"')
  sudo('mysql -u root -e "FLUSH PRIVILEGES;"')
  sudo('mysql -u development_user -pdevelopment_password -e "CREATE DATABASE development_db CHARACTER SET utf8;"')
  sudo('mysql -u test_user -ptest_password -e "CREATE DATABASE test_db CHARACTER SET utf8;"')
  sudo('mysql -u production_user -pproduction_password -e "CREATE DATABASE production_db CHARACTER SET utf8;"')

def redis():
  sudo('yum --enablerepo=remi install -y redis')
  sudo('chkconfig redis on')
  sudo('service redis start')


# デフォルトスワップサイズ(MB)
DEFAULT_SWAP_SIZE_MB = 1024
# スワップファイルのパス
SWAP_FILE = '/swapfile'

def create_swap():
  allocate(DEFAULT_SWAP_SIZE_MB)
  set_fstab()

def resize_swap(swap_size_mb):
  deallocate()
  allocate(swap_size_mb)

def allocate(swap_size_mb):
  sudo('fallocate -l %sm %s' % (swap_size_mb, SWAP_FILE))
  sudo('chmod 600 %s' % (SWAP_FILE))
  sudo('mkswap %s' % (SWAP_FILE))
  sudo('swapon %s' % (SWAP_FILE))

def deallocate():
  sudo('swapoff %s' % (SWAP_FILE))
  sudo('rm %s' % (SWAP_FILE))

def set_fstab():
  sudo('sh -c "echo \'%s swap swap defaults 0 0\' >> /etc/fstab"' % (SWAP_FILE))

