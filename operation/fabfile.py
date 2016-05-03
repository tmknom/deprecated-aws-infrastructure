# -*- encoding:utf-8 -*-
#
# 各種運用スクリプト
#
#####################################################################

from fabric.api import *

from security_group import security_group


@task
def sg_authorize():
    '''現在のアドレスから管理者VPCへのアクセス許可'''
    security_group.authorize()


@task
def sg_revoke():
    '''管理者VPCへのアクセス許可の取り消し'''
    security_group.revoke()
