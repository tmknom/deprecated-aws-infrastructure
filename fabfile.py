# -*- encoding:utf-8 -*-
#
# 管理用スクリプト
#
#####################################################################

from fabric.api import *

from bootstrapping.fabfile import ami_base
from bootstrapping.fabfile import ami_rails
from bootstrapping.fabfile import ami_tech_news
from configuration.fabfile import itamae_base
from configuration.fabfile import itamae_rails
from configuration.fabfile import itamae_tech_news
from configuration.fabfile import spec_base
from configuration.fabfile import spec_rails
from configuration.fabfile import spec_tech_news
from operation.fabfile import sg_authorize
from operation.fabfile import sg_revoke
from operation.fabfile import ec2_build_testing
from operation.fabfile import ec2_re_build_testing
from operation.fabfile import ec2_start_testing
from operation.fabfile import ec2_stop_testing
from operation.fabfile import ec2_remove_testing
from operation.fabfile import rds_start_administration
from operation.fabfile import rds_stop_administration
