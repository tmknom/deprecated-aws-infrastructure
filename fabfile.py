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
