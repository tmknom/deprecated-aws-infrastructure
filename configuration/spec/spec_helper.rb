require 'serverspec'
require 'net/ssh'
require 'highline/import'

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  set :sudo_password, ask('Enter sudo password: ') { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)

options[:keys] = ENV['KEY_PATH']
options[:user] = ENV['USER']
options[:host_name] = ENV['HOST_IP']
options[:port] = ENV['PORT']

set :host, options[:host_name] || host
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'

# 独自のヘルパーメソッド

# 指定したユーザでコマンド実行
# 参考 http://qiita.com/kazuhisa/items/f1f21806f879993a7167
def command_by_user(cmd, user)
  command("su -l #{user} -c '#{cmd}'")
end
