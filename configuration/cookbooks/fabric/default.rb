execute 'install fablic' do
  not_if "test -e /usr/local/bin/fab"
  command <<-EOL
    pip install --upgrade pip
    /usr/local/bin/pip install fabric
  EOL
  user 'root'
end

