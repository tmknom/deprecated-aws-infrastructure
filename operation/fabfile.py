# -*- encoding:utf-8 -*-
#
# 各種運用スクリプト
#
#####################################################################

from fabric.api import *

from security_group import security_group
from ec2 import ec2
from rds import rds
from rds import rds_password


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
def ec2_start_testing():
    '''テスト環境のEC2開始'''
    ec2.start_testing()


@task
def ec2_stop_testing():
    '''テスト環境のEC2停止'''
    ec2.stop_testing()


@task
def ec2_remove_testing():
    '''テスト環境のEC2削除'''
    ec2.remove_testing()


@task
def rds_start_administration():
    '''Administration 環境の RDS 起動'''
    rds.start_administration()


@task
def rds_stop_administration():
    '''Administration 環境の RDS 停止'''
    rds.stop_administration()


@task
def rds_production_password_change():
    '''Production 環境のRDSのパスワード変更'''
    rds_password.change_production()


@task
def rds_administration_password_change():
    '''Administration 環境のRDSのパスワード変更'''
    rds_password.change_administration()
