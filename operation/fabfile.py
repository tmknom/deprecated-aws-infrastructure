# -*- encoding:utf-8 -*-
#
# 各種運用スクリプト
#
#####################################################################

from fabric.api import *

from security_group import security_group
from ec2 import ec2


@task
def sg_authorize():
    '''現在のアドレスから管理者VPCへのアクセス許可'''
    security_group.authorize()


@task
def sg_revoke():
    '''管理者VPCへのアクセス許可の取り消し'''
    security_group.revoke()


@task
def ec2_build_testing():
    '''テスト環境のEC2構築'''
    ec2.build_testing()


@task
def ec2_re_build_testing():
    '''テスト環境のEC2再構築'''
    ec2.re_build_testing()


@task
def ec2_remove_testing():
    '''テスト環境のEC2削除'''
    ec2.remove_testing()
