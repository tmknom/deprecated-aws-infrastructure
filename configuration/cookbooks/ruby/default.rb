RUBY_VERSION = '2.3.0'

RBENV_DIR = '/opt/.rbenv'
RBENV_SHELL = '/etc/profile.d/rbenv.sh'
RBENV = "#{RBENV_DIR}/bin/rbenv"

# https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
%w(gcc gcc-c++ bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel).each do |pkg|
  package pkg
end

execute 'install rbenv' do
  not_if "test -e #{RBENV}"
  command <<-EOL
    git clone https://github.com/rbenv/rbenv.git #{RBENV_DIR}
    git clone https://github.com/rbenv/ruby-build.git #{RBENV_DIR}/plugins/ruby-build
    echo 'export RBENV_ROOT="/opt/.rbenv"' >> #{RBENV_SHELL}
    echo 'export PATH="/opt/.rbenv/bin:$PATH"' >> #{RBENV_SHELL}
    echo 'eval "$(rbenv init -)"' >> #{RBENV_SHELL}
  EOL
end

execute 'install ruby' do
  not_if "test -e #{RBENV_DIR}/versions/#{RUBY_VERSION}/bin/ruby"
  command <<-EOL
    source #{RBENV_SHELL}
    #{RBENV} install #{RUBY_VERSION}
    #{RBENV} global #{RUBY_VERSION}
    gem update --system --no-document
    gem update --no-document
  EOL
end

execute 'install bundler' do
  not_if "test -e #{RBENV_DIR}/versions/#{RUBY_VERSION}/bin//bundle"
  command <<-EOL
    source #{RBENV_SHELL}
    gem install bundler --no-document
  EOL
end
