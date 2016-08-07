include_recipe 'base.rb'

include_recipe '../cookbooks/nodejs/default.rb'
include_recipe '../cookbooks/nodejs/npm.rb'
include_recipe '../cookbooks/hubot/default.rb'
