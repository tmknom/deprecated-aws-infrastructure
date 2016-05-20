# -*- encoding:utf-8 -*-
#
# AMI構築スクリプト
#
#####################################################################

from fabric.api import *

BOOTSTRAPPING = 'bootstrapping'

BASE_ROLE = 'base'
RAILS_ROLE = 'rails'
TECH_NEWS_ROLE = 'tech_news'
WONDERFUL_WORLD_ROLE = 'wonderful_world'


@task
def ami_base():
    '''Base AMI の作成'''
    ami(BASE_ROLE)


@task
def ami_rails():
    '''Rails AMI の作成'''
    ami(RAILS_ROLE)


@task
def ami_tech_news():
    '''TechNews AMI の作成'''
    ami(TECH_NEWS_ROLE)


@task
def ami_wonderful_world():
    '''WonderfulWorld AMI の作成'''
    ami(WONDERFUL_WORLD_ROLE)


def ami(role):
    with lcd(get_current_dir()):
        local('go run bootstrapping.go %s' % (role))


def get_current_dir():
    import os
    return os.path.abspath(os.path.dirname(__file__))
