# User settings
USER_NAME = ENV['SSH_USER_NAME']
SSH_SHADOW_PASSWORD = ENV['SSH_SHADOW_PASSWORD']
SSH_PUBLIC_KEY_FULL_PATH = ENV['SSH_PUBLIC_KEY_FULL_PATH']

# Constant definition
WHEEL_GROUP_ID = '10'.to_i
WHEEL_GROUP_NAME = 'wheel'

# Add user
user USER_NAME do
  password SSH_SHADOW_PASSWORD
  gid WHEEL_GROUP_ID
end

# Setup ssh
directory "/home/#{USER_NAME}/.ssh" do
  owner USER_NAME
  group WHEEL_GROUP_NAME
  mode '700'
end

file "/home/#{USER_NAME}/.ssh/authorized_keys" do
  content File.read(SSH_PUBLIC_KEY_FULL_PATH)
  owner USER_NAME
  group WHEEL_GROUP_NAME
  mode '600'
end
