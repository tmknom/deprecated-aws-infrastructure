APPLICATION_USER_NAME = ENV['APPLICATION_USER_NAME']

# アプリケーション用 log ディレクトリ作成
directory "/var/log/app" do
  mode "700"
  owner APPLICATION_USER_NAME
  group APPLICATION_USER_NAME
end

# アプリケーション用 run ディレクトリ作成
directory "/var/run/app" do
  mode "700"
  owner APPLICATION_USER_NAME
  group APPLICATION_USER_NAME
end
