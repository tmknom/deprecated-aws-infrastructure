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
def prepare_tech_news():
    '''開発環境(tech-news)の準備'''
    tech_news_start()
    sg_authorize()
    rds_start_administration()


@task
def clear_tech_news():
    '''開発環境(tech-news)の後片付け'''
    sg_revoke()
    tech_news_stop()
    rds_stop_administration()


@task
def prepare_wonderful_world():
    '''開発環境(wonderful-world)の準備'''
    wonderful_world_start()
    sg_authorize()
    rds_start_administration()


@task
def clear_wonderful_world():
    '''開発環境(wonderful-world)の後片付け'''
    sg_revoke()
    wonderful_world_stop()
    rds_stop_administration()


@task
def sg_authorize():
    '''現在のアドレスから管理者VPCへのアクセス許可'''
    security_group.authorize()


@task
def sg_revoke():
    '''管理者VPCへのアクセス許可の取り消し'''
    security_group.revoke()


@task
def sg_authorize_http():
    '''現在のアドレスからHTTPへのアクセス許可'''
    security_group.authorize_http()


@task
def sg_revoke_http():
    '''HTTPへのアクセス許可の取り消し'''
    security_group.revoke_http()


@task
def ec2_list():
    '''EC2の一覧表示'''
    ec2.list()


@task
def tech_news_build():
    '''テスト環境(tech-news)のEC2構築'''
    ec2.build_tech_news()


@task
def tech_news_re_build():
    '''テスト環境(tech-news)のEC2再構築'''
    ec2.re_build_tech_news()


@task
def tech_news_start():
    '''テスト環境(tech-news)のEC2開始'''
    ec2.start_tech_news()


@task
def tech_news_stop():
    '''テスト環境(tech-news)のEC2停止'''
    ec2.stop_tech_news()


@task
def tech_news_remove():
    '''テスト環境(tech-news)のEC2削除'''
    ec2.remove_tech_news()


@task
def wonderful_world_build():
    '''テスト環境(wonderful-world)のEC2構築'''
    ec2.build_wonderful_world()


@task
def wonderful_world_re_build():
    '''テスト環境(wonderful-world)のEC2再構築'''
    ec2.re_build_wonderful_world()


@task
def wonderful_world_start():
    '''テスト環境(wonderful-world)のEC2開始'''
    ec2.start_wonderful_world()


@task
def wonderful_world_stop():
    '''テスト環境(wonderful-world)のEC2停止'''
    ec2.stop_wonderful_world()


@task
def wonderful_world_remove():
    '''テスト環境(wonderful-world)のEC2削除'''
    ec2.remove_wonderful_world()


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


@task
def rds_production_us_password_change():
    '''USのProduction 環境のRDSのパスワード変更'''
    rds_password.change_production_us()
