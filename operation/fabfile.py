# -*- encoding:utf-8 -*-
#
# 各種運用スクリプト
#
#####################################################################

from fabric.api import *

from security_group import ssh


@task
def ssh_authorize():
    '''現在のアドレスからSSH許可'''
    ssh.authorize()
