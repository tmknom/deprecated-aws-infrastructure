# -*- encoding:utf-8 -*-
#
# 管理用スクリプト
#
#####################################################################

from fabric.api import *

from configuration.fabfile import itamae_base
from configuration.fabfile import itamae_rails
from configuration.fabfile import itamae_tech_news
from configuration.fabfile import spec_base
from configuration.fabfile import spec_rails
from configuration.fabfile import spec_tech_news
from operation.fabfile import sg_authorize
from operation.fabfile import sg_revoke

BOOTSTRAPPING = 'bootstrapping'

BASE_ROLE = 'base'
RAILS_ROLE = 'rails'


@task
def ami_base():
    '''Base AMI の作成'''
    ami(BASE_ROLE)


@task
def ami_rails():
    '''Rails AMI の作成'''
    ami(RAILS_ROLE)


def ami(role):
    with lcd(BOOTSTRAPPING):
        local('go run bootstrapping.go %s' % (role))
