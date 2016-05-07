execute 'backup /etc/sudoers' do
  command 'cp -p /etc/sudoers /etc/sudoers.org'
  not_if 'test -e /etc/sudoers.org'
  user 'root'
end

execute 'enable sudo wheel' do
  not_if "cat /etc/sudoers | grep '^%wheel'"
  command 'sed -i \'s/^# %wheel\(\s\+ALL=(ALL)\s\+ALL$\)/%wheel\1/\' /etc/sudoers'
end
