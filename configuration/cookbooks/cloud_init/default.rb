CLOUD_INIT_CONFIG = '/etc/cloud/cloud.cfg'

execute 'disable auto update' do
  # http://dev.classmethod.jp/cloud/five-confs-of-ec2-linux-sysops/
  not_if "cat #{CLOUD_INIT_CONFIG} | grep '^repo_upgrade: none'"
  command "sed -i 's/^repo_upgrade:\s\\+security/repo_upgrade: none/' #{CLOUD_INIT_CONFIG}"
end
