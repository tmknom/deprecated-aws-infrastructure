CLOUD_INIT_CONFIG = '/etc/cloud/cloud.cfg'
I18N_CONFIG = '/etc/sysconfig/i18n'
LOCALTIME_CONFIG = '/etc/localtime'
CLOCK_CONFIG = '/etc/sysconfig/clock'

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

execute 'set timezone Asia/Tokyo' do
  # http://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/set-time.html
  not_if "cat #{CLOCK_CONFIG} | grep '^ZONE=\"Asia\\/Tokyo\"'"
  command <<-EOL
    ln -sf /usr/share/zoneinfo/Asia/Tokyo #{LOCALTIME_CONFIG}
    sed -i 's/^ZONE=\"UTC\"/ZONE=\"Asia\\/Tokyo\"/' #{CLOCK_CONFIG}
    sed -i 's/^UTC=true/UTC=false/' #{CLOCK_CONFIG}
  EOL
end
