INSTALL_PACKAGES = %w(git jq tree telnet sysstat strace)

INSTALL_PACKAGES.each do |pkg|
  package pkg
end

service 'sendmail' do
  action [:disable, :stop]
end
