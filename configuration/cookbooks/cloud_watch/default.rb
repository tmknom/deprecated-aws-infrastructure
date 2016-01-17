ZIP_FILE = 'CloudWatchMonitoringScripts-1.2.1.zip'
SCRIPT_FILE = '/opt/aws/aws-scripts-mon/mon-put-instance-data.pl'

# https://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/DeveloperGuide/mon-scripts.html
%w(perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https).each do |pkg|
  package pkg
end

execute 'install cloud watch scripts' do
  not_if "test -e #{SCRIPT_FILE}"
  command <<-EOL
    mkdir -p /opt/aws
    wget http://aws-cloudwatch.s3.amazonaws.com/downloads/#{ZIP_FILE}
    unzip #{ZIP_FILE} -d /opt/aws
    rm #{ZIP_FILE}
  EOL
end

execute 'set cron cloud watch' do
  not_if "cat /var/spool/cron/root | grep '#{SCRIPT_FILE}'"
  command "echo '*/5 * * * * #{SCRIPT_FILE} --mem-util --mem-used --swap-util --swap-used --disk-space-util --disk-space-used --disk-path=/ --from-cron' >> /var/spool/cron/root"
end
