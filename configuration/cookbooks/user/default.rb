# User settings
USER_NAME = ENV['SSH_USER_NAME']
PASSWORD = ENV['SSH_USER_PASSWORD']
SSH_PUBLIC_KEY = ENV['SSH_PUBLIC_KEY']

# Constant definition
WHEEL_GROUP = '10'

# Add user
user USER_NAME do
  password PASSWORD
  gid WHEEL_GROUP
end

# Setup ssh
directory "/home/#{USER_NAME}/.ssh" do
  owner USER_NAME
  group WHEEL_GROUP
  mode '700'
end

file "/home/#{USER_NAME}/.ssh/authorized_keys" do
  content SSH_PUBLIC_KEY
  owner USER_NAME
  group WHEEL_GROUP
  mode '600'
end
