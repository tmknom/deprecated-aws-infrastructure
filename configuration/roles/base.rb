# user
include_recipe '../cookbooks/user/default.rb'

# security
include_recipe '../cookbooks/sudo/default.rb'
include_recipe '../cookbooks/sshd/default.rb'

# rpm
include_recipe '../cookbooks/rpm_repository/default.rb'
include_recipe '../cookbooks/rpm_package/default.rb'
include_recipe '../cookbooks/rpm_package/update.rb'

# monitoring
include_recipe '../cookbooks/command_log/default.rb'
include_recipe '../cookbooks/monit/default.rb'

# general
include_recipe '../cookbooks/logrotate/default.rb'
#include_recipe '../cookbooks/swap/default.rb'

# AWS
include_recipe '../cookbooks/cloud_init/default.rb'
include_recipe '../cookbooks/cloud_watch/default.rb'
include_recipe '../cookbooks/code_deploy/default.rb'
#include_recipe '../cookbooks/ec2_user/default.rb' # ec2-user自体を削除するため必ず最後に実行する
