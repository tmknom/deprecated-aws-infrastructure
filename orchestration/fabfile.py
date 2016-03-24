# -*- encoding:utf-8 -*-
#
# 各種リソースの構築スクリプト
#
#####################################################################

from fabric.api import *

from terraform.cli.cli_helper import *
from rds.cli.password_changer import *
from helper import *

@task
def build_sg_production():
  '''本番環境のセキュリティグループ構築'''
  tf_vars = get_production_tf_vars()
  terraform_apply('security_group/production', tf_vars)

@task
def build_sg_testing():
  '''テスト環境のセキュリティグループ構築'''
  tf_vars = get_testing_tf_vars()
  terraform_apply('security_group/testing', tf_vars)

@task
def build_rds_production():
  '''本番環境のRDS構築'''
  tf_vars = get_production_db_tf_vars()
  terraform_apply('rds/production', tf_vars)
  change_password('production-mysql')

@task
def build_rds_testing():
  '''テスト環境のRDS構築'''
  tf_vars = get_testing_db_tf_vars()
  terraform_apply('rds/testing', tf_vars)
  change_password('testing-mysql')

@task
def build_vpc_production():
  '''本番環境のVPC構築'''
  terraform_apply('vpc/production/tokyo')

@task
def build_vpc_testing():
  '''テスト環境のVPC構築'''
  terraform_apply('vpc/testing/tokyo')

@task
def build_code_deploy():
  '''CodeDeploy構築'''
  terraform_apply('code_deploy')

@task
def build_instance_profile():
  '''InstanceProfileの構築'''
  terraform_apply('instance_profile/rails')

@task
def build_user_cli():
  '''CLIユーザの構築'''
  terraform_apply('iam_user/cli/administrator')

@task
def build_user_external():
  '''AWS外部用システムユーザの構築'''
  terraform_apply('iam_user/external/circle_ci')

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

