# -*- encoding:utf-8 -*-

import json
from fabric.api import *

ROLE_SSH = 'SSH'
ROLE_RAILS = 'Rails'

NETWORK_PUBLIC = 'Public'
NETWORK_PRIVATE = 'Private'


def get_tf_vars(environment):
    vpc_id = get_vpc_id(environment)
    availability_zones = get_availability_zones()
    result = ' TF_VAR_production_vpc_id=%s' % (vpc_id) \
             + ' TF_VAR_availability_zones=%s' % (availability_zones)
    return result


def get_ec2_tf_vars(environment, role):
    aws_account_id = get_aws_account_id()
    ami_id = get_latest_ami_id(role, aws_account_id)
    subnet_id = get_ec2_subnet_ids(environment)
    security_group_id = get_security_group_id(environment, role)
    ssh_security_group_id = get_security_group_id(environment, ROLE_SSH)
    created = get_created()

    result = ' TF_VAR_ami_id=%s' % (ami_id) \
             + ' TF_VAR_subnet_id=%s' % (subnet_id) \
             + ' TF_VAR_security_group_id=%s' % (security_group_id) \
             + ' TF_VAR_ssh_security_group_id=%s' % (ssh_security_group_id) \
             + ' TF_VAR_created=%s' % (created)
    return result


def get_created():
    from datetime import datetime
    return datetime.now().strftime("%s")


def get_ec2_subnet_ids(environment):
    subnet_ids = get_subnet_ids(environment, NETWORK_PUBLIC)
    return subnet_ids[1]


def get_latest_ami_id(role, aws_account_id):
    command = 'aws ec2 describe-images' \
              + ' --filters ' \
              + ' "Name=owner-id,Values=' + aws_account_id + '"' \
              + ' "Name=tag:Role,Values=' + role + '"' \
              + ' --query \'' \
              + ' sort_by(Images[].{ ' \
              + ' AmiId: ImageId, ' \
              + ' Created:Tags[?Key==`Created`].Value|[0] ' \
              + ' }, &Created) ' \
              + ' | reverse(@) ' \
              + ' | [0] \' ' \
              + ' | jq -r .AmiId '
    result = local(command, capture=True)
    return result


def get_db_tf_vars(environment):
    db_subnet_ids = get_db_subnet_ids(environment)
    db_source_security_group_id = get_db_source_security_group_id(environment)
    result = get_tf_vars(environment) \
             + ' TF_VAR_db_subnet_ids=%s' % (db_subnet_ids) \
             + ' TF_VAR_db_source_security_group_id=%s' % (db_source_security_group_id)
    return result


def get_db_source_security_group_id(environment):
    return get_security_group_id(environment, ROLE_RAILS)


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
    subnet_ids = get_subnet_ids(environment, NETWORK_PRIVATE)
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


def get_aws_account_id():
    command = "aws cloudtrail describe-trails" \
              + " | jq '.trailList[] | select(.IsMultiRegionTrail == true)' " \
              + " | jq -r '.TrailARN' " \
              + " | cut -d: -f5 "
    result = local(command, capture=True)
    return result
