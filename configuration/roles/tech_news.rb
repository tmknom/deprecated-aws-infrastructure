include_recipe 'rails.rb'

include_recipe '../cookbooks/application/default.rb'
include_recipe '../cookbooks/application/tech_news.rb'
include_recipe '../cookbooks/logrotate/app.rb'
