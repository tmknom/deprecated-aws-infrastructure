execute 'delete ec2-user' do
  only_if 'cat /etc/passwd | grep ec2-user'
  command 'userdel -rf ec2-user'
end
