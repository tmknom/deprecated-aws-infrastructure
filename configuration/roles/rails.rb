include_recipe 'base.rb'

include_recipe '../cookbooks/ruby/default.rb'
include_recipe '../cookbooks/nodejs/default.rb'
include_recipe '../cookbooks/mysql/default.rb'
include_recipe '../cookbooks/redis/default.rb'
include_recipe '../cookbooks/fabric/default.rb'
include_recipe '../cookbooks/code_deploy/default.rb'
