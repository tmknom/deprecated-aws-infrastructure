# -*- encoding:utf-8 -*-
#
# 管理用スクリプト
#
#####################################################################

from fabric.api import *

from operation.fabfile import prepare_tech_news
from operation.fabfile import clear_tech_news
from operation.fabfile import prepare_wonderful_world
from operation.fabfile import clear_wonderful_world
from operation.fabfile import sg_authorize_http
from operation.fabfile import ec2_list
from operation.fabfile import tech_news_build
from operation.fabfile import tech_news_re_build
from operation.fabfile import wonderful_world_build
from operation.fabfile import wonderful_world_re_build


@task
def help(module_name=''):
    '''タスク一覧 [:bootstrapping :configuration :orchestration :operation]'''
    if module_name == '':
        fab_list('bootstrapping')
        fab_list('configuration')
        fab_list('orchestration')
        fab_list('operation')
    else:
        fab_list(module_name)


def fab_list(dir_name):
    print('\n')
    local('fab -l -f %s/fabfile.py' % (dir_name))
