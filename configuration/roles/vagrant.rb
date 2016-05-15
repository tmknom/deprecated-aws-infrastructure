# base
include_recipe '../cookbooks/rpm_repository/default.rb'
include_recipe '../cookbooks/rpm_package/default.rb'

# rails
include_recipe '../cookbooks/mysql_client/default.rb'
include_recipe '../cookbooks/nodejs/default.rb'
include_recipe '../cookbooks/redis/default.rb'
include_recipe '../cookbooks/ruby/default.rb'
include_recipe '../cookbooks/user/rails.rb'
include_recipe '../cookbooks/nginx/default.rb'

# tech-news
include_recipe '../cookbooks/application/default.rb'
include_recipe '../cookbooks/application/tech_news.rb'

# vagrant only
include_recipe '../cookbooks/mysql_server/default.rb'
