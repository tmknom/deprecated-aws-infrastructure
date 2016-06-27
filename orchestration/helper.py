# -*- encoding:utf-8 -*-

import json
from fabric.api import *

REGION_US = 'us-west-1'
REGION_JP = 'ap-northeast-1'

ENVIRONMENT_PRODUCTION = 'Production'
ENVIRONMENT_ADMINISTRATION = 'Administration'

ROLE_SSH = 'SSH'
ROLE_RAILS = 'Rails'
ROLE_MYSQL_CLIENT = 'MySQLClient'
ROLE_INTERNAL_RAILS = 'InternalRails'

IAM_ROLE_CODE_DEPLOY = 'CodeDeployRole'

NETWORK_PUBLIC = 'Public'
NETWORK_PRIVATE = 'Private'

TECH_NEWS = 'TechNews'
WONDERFUL_WORLD = 'WonderfulWorld'


def get_tf_vars(region=REGION_JP):
    production_vpc_id = get_vpc_id(ENVIRONMENT_PRODUCTION, region)
    administration_vpc_id = get_vpc_id(ENVIRONMENT_ADMINISTRATION, region)
    availability_zones = get_availability_zones(region)
    result = ' TF_VAR_production_vpc_id=%s' % (production_vpc_id) \
             + ' TF_VAR_administration_vpc_id=%s' % (administration_vpc_id) \
             + ' TF_VAR_availability_zones=%s' % (availability_zones)
    return result


def get_ec2_tf_vars(environment, role, application, region=REGION_JP):
    aws_account_id = get_aws_account_id()
    ami_id = get_latest_ami_id(application, aws_account_id, region)
    subnet_id = get_ec2_subnet_ids(environment, region)
    security_group_id = get_security_group_id(environment, role, region)
    rds_security_group_id = get_security_group_id(environment, ROLE_MYSQL_CLIENT, region)
    ssh_security_group_id = get_security_group_id(environment, ROLE_SSH, region)
    created = get_created()

    result = ' TF_VAR_ami_id=%s' % (ami_id) \
             + ' TF_VAR_subnet_id=%s' % (subnet_id) \
             + ' TF_VAR_security_group_id=%s' % (security_group_id) \
             + ' TF_VAR_rds_security_group_id=%s' % (rds_security_group_id) \
             + ' TF_VAR_ssh_security_group_id=%s' % (ssh_security_group_id) \
             + ' TF_VAR_created=%s' % (created)
    return result


def get_created():
    from datetime import datetime
    return datetime.now().strftime("%s")


def get_ec2_subnet_ids(environment, region):
    subnet_ids = get_subnet_ids(environment, NETWORK_PUBLIC, region)
    return subnet_ids[1]


def get_latest_ami_id(role, aws_account_id, region):
    command = 'aws ec2 describe-images' \
              + " --region %s " % (region) \
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


def get_elb_tf_vars(environment, region=REGION_JP):
    public_subnet_ids = get_public_subnet_ids(environment, region)
    elb_security_groups = get_elb_security_groups(environment, region)
    result = get_tf_vars(region) \
             + ' TF_VAR_public_subnet_ids=%s' % (public_subnet_ids) \
             + ' TF_VAR_elb_security_groups=%s' % (elb_security_groups)
    return result


def get_elb_security_groups(environment, region):
    return get_security_group_id(environment, ROLE_RAILS, region)


def get_public_subnet_ids(environment, region):
    subnet_ids = get_subnet_ids(environment, NETWORK_PUBLIC, region)
    return ','.join(subnet_ids)


def get_db_tf_vars(region=REGION_JP):
    production_db_subnet_ids = get_db_subnet_ids(ENVIRONMENT_PRODUCTION, region)
    production_db_source_security_group_id = get_db_source_security_group_id(ENVIRONMENT_PRODUCTION, region)
    administration_db_subnet_ids = get_db_subnet_ids(ENVIRONMENT_ADMINISTRATION, region)
    administration_db_source_security_group_id = get_db_source_security_group_id(ENVIRONMENT_ADMINISTRATION, region)
    result = get_tf_vars(region) \
             + ' TF_VAR_administration_db_subnet_ids=%s' % (administration_db_subnet_ids) \
             + ' TF_VAR_administration_db_source_security_group_id=%s' % (administration_db_source_security_group_id) \
             + ' TF_VAR_production_db_subnet_ids=%s' % (production_db_subnet_ids) \
             + ' TF_VAR_production_db_source_security_group_id=%s' % (production_db_source_security_group_id)
    return result


def get_db_source_security_group_id(environment, region):
    return get_security_group_id(environment, ROLE_MYSQL_CLIENT, region)


def get_db_subnet_ids(environment, region):
    subnet_ids = get_subnet_ids(environment, NETWORK_PRIVATE, region)
    return ','.join(subnet_ids)


def get_code_deploy_tf_vars():
    role_arn = get_role_arn(IAM_ROLE_CODE_DEPLOY)
    result = ' TF_VAR_code_deploy_role_arn=%s' % (role_arn)
    return result


def get_role_arn(iam_role):
    command = "aws iam list-roles " \
              + " | jq -r '.Roles[] | select(.RoleName == \"%s\") | .Arn' " % (iam_role)
    result = local(command, capture=True)
    return result


def get_security_group_id(environment, role, region):
    command = "aws ec2 describe-security-groups " \
              + " --region %s " % (region) \
              + " --filters " \
              + " 'Name=tag-key,Values=Environment' " \
              + " 'Name=tag-value,Values=%s' " % (environment) \
              + " 'Name=tag-key,Values=Role' " \
              + " 'Name=tag-value,Values=%s' " % (role) \
              + " | jq -r '.SecurityGroups[].GroupId' "
    result = local(command, capture=True)
    return result


def get_subnet_ids(environment, network, region):
    command = "aws ec2 describe-subnets " \
              + " --region %s " % (region) \
              + " --filters " \
              + " 'Name=tag-key,Values=Environment' " \
              + " 'Name=tag-value,Values=%s' " % (environment) \
              + " 'Name=tag-key,Values=Network' " \
              + " 'Name=tag-value,Values=%s' " % (network) \
              + " | jq '.Subnets' | jq 'map(.SubnetId)' "
    result = local(command, capture=True)
    return json.loads(result)


def get_availability_zones(region):
    command = "aws ec2 describe-availability-zones " \
              + " --region %s " % (region) \
              + " | jq '.AvailabilityZones' | jq 'map(.ZoneName)' "
    result = local(command, capture=True)
    return ','.join(json.loads(result))


def get_vpc_id(environment, region):
    command = "aws ec2 describe-vpcs " \
              + " --region %s " % (region) \
              + " --filters " \
              + " 'Name=tag-key,Values=Environment' " \
              + " 'Name=tag-value,Values=%s' " % (environment) \
              + " | jq -r '.Vpcs[0].VpcId' "
    result = local(command, capture=True)
    return result


def get_aws_account_id():
    command = "aws sts get-caller-identity | jq -r .Account"
    result = local(command, capture=True)
    return result
