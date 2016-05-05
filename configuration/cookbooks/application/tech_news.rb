# RDS
DATABASE_HOST = ENV['DATABASE_HOST']
DATABASE_PORT = ENV['DATABASE_PORT']

# アプリケーション固有
DATABASE_DB = ENV['TECH_NEWS_DATABASE_DB']
DATABASE_USER_NAME = ENV['TECH_NEWS_DATABASE_USER_NAME']
DATABASE_USER_PASSWORD = ENV['TECH_NEWS_DATABASE_USER_PASSWORD']
SECRET_KEY_BASE = ENV['TECH_NEWS_SECRET_KEY_BASE']

APPLICATION_USER = 'ec2-user'
BASE_DIR = '/home/ec2-user'

# Railsアプリケーション用ログディレクトリ作成
directory "/var/log/app" do
  mode "777"
  owner APPLICATION_USER
  group APPLICATION_USER
end

# pidディレクトリ作成
directory "#{BASE_DIR}/tmp/pids" do
  mode "755"
  owner APPLICATION_USER
  group APPLICATION_USER
end

# CodeDeploy対応
directory "/opt/codedeploy-agent/.bundle" do
  mode "755"
  owner APPLICATION_USER
  group APPLICATION_USER
end
