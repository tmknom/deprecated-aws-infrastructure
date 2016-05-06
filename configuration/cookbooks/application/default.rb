APPLICATION_USER = 'ec2-user'

# アプリケーション用 log ディレクトリ作成
directory "/var/log/app" do
  mode "777"
  owner APPLICATION_USER
  group APPLICATION_USER
end

# アプリケーション用 run ディレクトリ作成
directory "/var/run/app" do
  mode "777"
  owner APPLICATION_USER
  group APPLICATION_USER
end
