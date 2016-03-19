# -*- encoding:utf-8 -*-

from fabric.api import *

def get_production_tf_vars():
  return get_tf_vars('Production')

def get_testing_tf_vars():
  return get_tf_vars('Testing')

def get_tf_vars(environment):
  vpc_id = get_vpc_id(environment)
  result = 'TF_VAR_vpc_id=%s' % (vpc_id)
  return result

def get_vpc_id(environment):
  command = "aws ec2 describe-vpcs " \
          + " --filters " \
          + " 'Name=tag-key,Values=Environment' " \
          + " 'Name=tag-value,Values=%s' " % (environment) \
          + " | jq -r '.Vpcs[0].VpcId' "
  result = local(command, capture=True)
  return result

