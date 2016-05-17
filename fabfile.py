# -*- encoding:utf-8 -*-
#
# 管理用スクリプト
#
#####################################################################

from fabric.api import *

from operation.fabfile import prepare
from operation.fabfile import clear
from operation.fabfile import sg_authorize_http
from operation.fabfile import ec2_list
from operation.fabfile import ec2_build_testing
from operation.fabfile import ec2_re_build_testing


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
