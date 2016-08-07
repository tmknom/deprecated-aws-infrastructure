execute 'install hubot' do
  not_if "which hubot 2>/dev/null"
  command 'npm install -g hubot coffee-script yo generator-hubot forever'
end
