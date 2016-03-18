# -*- encoding:utf-8 -*-
#
# 各種リソースの更新スクリプト
#
#####################################################################

from fabric.api import *
from terraform.cli.cli_helper import *

@task
def update_s3_log():
  '''s3-log バケットの更新'''
  terraform_apply('s3/s3_log')

@task
def update_s3_terraform():
  '''terraform バケットの更新'''
  terraform_apply('s3/terraform')

@task
def update_s3_cloud_trail():
  '''cloud-trail バケットの更新'''
  terraform_apply('s3/cloud_trail')

@task
def update_cloud_trail():
  '''CloudTrailの更新'''
  terraform_apply('cloud_trail')

