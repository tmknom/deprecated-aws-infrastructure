# -*- encoding:utf-8 -*-
#
# 管理用スクリプト
#
#####################################################################

from fabric.api import *

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
