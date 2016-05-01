# User settings
USER_NAME = ENV['SSH_USER_NAME']
SSH_SHADOW_PASSWORD = ENV['SSH_SHADOW_PASSWORD']
SSH_PUBLIC_KEY_FULL_PATH = ENV['SSH_PUBLIC_KEY_FULL_PATH']

# Constant definition
WHEEL_GROUP = '10'

# Add user
user USER_NAME do
  password SSH_SHADOW_PASSWORD
  gid WHEEL_GROUP
end

# Setup ssh
directory "/home/#{USER_NAME}/.ssh" do
  owner USER_NAME
  group WHEEL_GROUP
  mode '700'
end

file "/home/#{USER_NAME}/.ssh/authorized_keys" do
  content File.read(SSH_PUBLIC_KEY_FULL_PATH)
  owner USER_NAME
  group WHEEL_GROUP
  mode '600'
end
