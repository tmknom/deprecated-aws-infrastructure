# -*- encoding:utf-8 -*-

import json
from fabric.api import *

def get_production_tf_vars():
  return get_tf_vars('Production')

def get_testing_tf_vars():
  return get_tf_vars('Testing')

def get_production_db_tf_vars():
  return get_db_tf_vars('Production')

def get_testing_db_tf_vars():
  return get_db_tf_vars('Testing')

def get_tf_vars(environment):
  vpc_id = get_vpc_id(environment)
  availability_zones = get_availability_zones()
  result = ' TF_VAR_vpc_id=%s' % (vpc_id) \
         + ' TF_VAR_availability_zones=%s' % (availability_zones)
  return result

def get_db_tf_vars(environment):
  db_subnet_ids = get_db_subnet_ids(environment)
  db_source_security_group_id = get_db_source_security_group_id(environment)
  result = get_tf_vars(environment) \
         + ' TF_VAR_db_subnet_ids=%s' % (db_subnet_ids) \
         + ' TF_VAR_db_source_security_group_id=%s' % (db_source_security_group_id)
  return result

def get_db_source_security_group_id(environment):
  return get_security_group_id(environment, 'Rails')

def get_security_group_id(environment, role):
  command = "aws ec2 describe-security-groups " \
          + " --filters " \
          + " 'Name=tag-key,Values=Environment' " \
          + " 'Name=tag-value,Values=%s' " % (environment) \
          + " 'Name=tag-key,Values=Role' " \
          + " 'Name=tag-value,Values=%s' " % (role) \
          + " | jq -r '.SecurityGroups[].GroupId' "
  result = local(command, capture=True)
  return result

def get_db_subnet_ids(environment):
  subnet_ids = get_subnet_ids(environment, 'Private')
  return ','.join(subnet_ids)

def get_subnet_ids(environment, network):
  command = "aws ec2 describe-subnets " \
          + " --filters " \
          + " 'Name=tag-key,Values=Environment' " \
          + " 'Name=tag-value,Values=%s' " % (environment) \
          + " 'Name=tag-key,Values=Network' " \
          + " 'Name=tag-value,Values=%s' " % (network) \
          + " | jq '.Subnets' | jq 'map(.SubnetId)' "
  result = local(command, capture=True)
  return json.loads(result)

def get_availability_zones():
  command = "aws ec2 describe-availability-zones " \
          + " | jq '.AvailabilityZones' | jq 'map(.ZoneName)' "
  result = local(command, capture=True)
  return ','.join(json.loads(result))

def get_vpc_id(environment):
  command = "aws ec2 describe-vpcs " \
          + " --filters " \
          + " 'Name=tag-key,Values=Environment' " \
          + " 'Name=tag-value,Values=%s' " % (environment) \
          + " | jq -r '.Vpcs[0].VpcId' "
  result = local(command, capture=True)
  return result

