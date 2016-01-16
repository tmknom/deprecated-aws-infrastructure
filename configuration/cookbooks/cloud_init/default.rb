CLOUD_INIT_CONFIG = '/etc/cloud/cloud.cfg'
I18N_CONFIG = '/etc/sysconfig/i18n'

execute 'disable auto update' do
  # http://dev.classmethod.jp/cloud/five-confs-of-ec2-linux-sysops/
  not_if "cat #{CLOUD_INIT_CONFIG} | grep '^repo_upgrade: none'"
  command "sed -i 's/^repo_upgrade:\s\\+security/repo_upgrade: none/' #{CLOUD_INIT_CONFIG}"
end

execute 'set locale ja_JP' do
  not_if "cat #{CLOUD_INIT_CONFIG} | grep '^locale: ja_JP.UTF-8'"
  command <<-EOL
    echo 'locale: ja_JP.UTF-8' >> #{CLOUD_INIT_CONFIG}
    sed -i 's/en_US/ja_JP/' #{I18N_CONFIG}
  EOL
end
