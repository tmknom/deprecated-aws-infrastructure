INSTALL_PACKAGES = %w(wget jq zip unzip tree telnet sysstat strace)

execute 'yum all update' do
  command 'yum update -y'
end

INSTALL_PACKAGES.each do |pkg|
  package pkg
end
