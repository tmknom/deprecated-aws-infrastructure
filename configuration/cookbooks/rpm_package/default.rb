INSTALL_PACKAGES = %w(git jq tree telnet sysstat strace)

execute 'yum all update' do
  command 'yum update -y'
end

INSTALL_PACKAGES.each do |pkg|
  package pkg
end
