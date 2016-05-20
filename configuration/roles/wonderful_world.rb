include_recipe 'rails.rb'

include_recipe '../cookbooks/swap/default.rb'

include_recipe '../cookbooks/application/default.rb'
include_recipe '../cookbooks/application/wonderful_world.rb'
include_recipe '../cookbooks/logrotate/app.rb'
