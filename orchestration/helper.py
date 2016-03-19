# -*- encoding:utf-8 -*-

from fabric.api import *

def set_production_vpc_id():
  set_vpc_id('Production')

def set_testing_vpc_id():
  set_vpc_id('Testing')

def set_vpc_id(environment):
  vpc_id = get_vpc_id(environment)
  local('export TF_VAR_vpc_id=%s' % (vpc_id))

def get_vpc_id(environment):
  command = "aws ec2 describe-vpcs " \
          + " --filters " \
          + " 'Name=tag-key,Values=Environment' " \
          + " 'Name=tag-value,Values=%s' " % (environment) \
          + " | jq -r '.Vpcs[0].VpcId' "
  result = local(command, capture=True)
  return result

