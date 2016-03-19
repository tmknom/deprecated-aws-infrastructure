# -*- encoding:utf-8 -*-
#
# 各種リソースの構築スクリプト
#
#####################################################################

from fabric.api import *
from terraform.cli.cli_helper import *

@task
def build_vpc_production():
  '''本番環境のVPC構築'''
  terraform_apply('vpc/production/tokyo')

@task
def build_instance_profile():
  '''InstanceProfileの構築'''
  terraform_apply('instance_profile/rails')

@task
def build_user_cli():
  '''CLIユーザの構築'''
  terraform_apply('iam_user/cli/administrator')

@task
def build_s3_log():
  '''s3-log バケットの構築'''
  terraform_apply('s3/s3_log')

@task
def build_s3_terraform():
  '''terraform バケットの構築'''
  terraform_apply('s3/terraform')

@task
def build_s3_cloud_trail():
  '''cloud-trail バケットの構築'''
  terraform_apply('s3/cloud_trail')

@task
def build_cloud_trail():
  '''CloudTrailの構築'''
  terraform_apply('cloud_trail')

