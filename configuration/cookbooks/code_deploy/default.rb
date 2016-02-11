REGION = 'ap-northeast-1'

execute 'install codedeploy agent' do
  not_if "test -e /etc/rc.d/init.d/codedeploy-agent"
  command <<-EOL
    aws s3 cp s3://aws-codedeploy-#{REGION}/latest/install . --region #{REGION}
    chmod +x ./install
    ./install auto
    rm ./install
  EOL
end

