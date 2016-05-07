# -*- encoding:utf-8 -*-

import json
from fabric.api import *

ENVIRONMENT_TESTING = 'Testing'
ENVIRONMENT_PRODUCTION = 'Production'

ROLE_SSH = 'SSH'
ROLE_RAILS = 'Rails'
ROLE_MYSQL_CLIENT = 'MySQLClient'
ROLE_TECH_NEWS = 'TechNews'

NETWORK_PUBLIC = 'Public'

APPLICATION_TECH_NEWS = 'tech-news'


def re_build_testing():
    remove_testing()
    build_testing()


def build_testing():
    instance_id = create_instance()
    create_instance_tag(instance_id)


def start_testing():
    instance_id = get_instance_id(ENVIRONMENT_TESTING, ROLE_RAILS, APPLICATION_TECH_NEWS)
    start_instances(instance_id)


def stop_testing():
    instance_id = get_instance_id(ENVIRONMENT_TESTING, ROLE_RAILS, APPLICATION_TECH_NEWS)
    stop_instances(instance_id)


def remove_testing():
    instance_id = get_instance_id(ENVIRONMENT_TESTING, ROLE_RAILS, APPLICATION_TECH_NEWS)
    terminate_instances(instance_id)


def create_instance():
    ami_id = get_ami_id(ROLE_TECH_NEWS)
    subnet_id = get_subnet_id(ENVIRONMENT_PRODUCTION, NETWORK_PUBLIC)
    security_group_id = get_security_group_id(ENVIRONMENT_PRODUCTION, ROLE_RAILS)
    ssh_security_group_id = get_security_group_id(ENVIRONMENT_PRODUCTION, ROLE_SSH)
    rds_security_group_id = get_security_group_id(ENVIRONMENT_PRODUCTION, ROLE_MYSQL_CLIENT)
    return run_instances(ami_id, subnet_id, security_group_id, ssh_security_group_id, rds_security_group_id)


def create_instance_tag(instance_id):
    create_tags(instance_id, 'Application', APPLICATION_TECH_NEWS)
    create_tags(instance_id, 'DeploymentGroup', '-'.join([ENVIRONMENT_TESTING, APPLICATION_TECH_NEWS]).lower())
    create_tags(instance_id, 'Environment', ENVIRONMENT_TESTING)
    create_tags(instance_id, 'Name', '-'.join([ENVIRONMENT_TESTING, ROLE_RAILS, APPLICATION_TECH_NEWS]))
    create_tags(instance_id, 'Roles', ROLE_RAILS)


def run_instances(ami_id, subnet_id, security_group_id, ssh_security_group_id, rds_security_group_id):
    command = "aws ec2 run-instances  " \
              + " --image-id %s " % (ami_id) \
              + " --subnet-id %s " % (subnet_id) \
              + " --security-group-ids %s %s %s " % (security_group_id, ssh_security_group_id, rds_security_group_id) \
              + " --instance-type t2.micro " \
              + " --iam-instance-profile Name=RailsInstanceProfile " \
              + " --associate-public-ip-address " \
              + " --block-device-mappings " \
              + ' \'[{"DeviceName":"/dev/xvda", ' \
              + ' "Ebs":{"VolumeSize":8,"DeleteOnTermination":true,"VolumeType": "gp2"}}]\' ' \
              + " | jq -r '.Instances[].InstanceId' "
    result = local(command, capture=True)
    return result


def get_subnet_id(environment, network):
    command = "aws ec2 describe-subnets " \
              + " --filters " \
              + " 'Name=tag-key,Values=Environment' " \
              + " 'Name=tag-value,Values=%s' " % (environment) \
              + " 'Name=tag-key,Values=Network' " \
              + " 'Name=tag-value,Values=%s' " % (network) \
              + " | jq '.Subnets' | jq 'map(.SubnetId)' "
    result = local(command, capture=True)
    return json.loads(result)[1]


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


def get_ami_id(role):
    command = "aws ec2 describe-images " \
              + " --filters " \
              + " 'Name=tag-key,Values=Role' " \
              + " 'Name=tag-value,Values=%s' " % (role) \
              + " | jq -r '.Images[].ImageId' "
    result = local(command, capture=True)
    return result


def create_tags(instance_id, tag_key, tag_value):
    command = "aws ec2 create-tags " \
              + " --resources %s " % (instance_id) \
              + " --tags Key=%s,Value=%s " % (tag_key, tag_value)
    local(command)


def start_instances(instance_id):
    command = "aws ec2 start-instances " \
              + " --instance-ids %s " % (instance_id)
    result = local(command, capture=True)
    return result


def stop_instances(instance_id):
    command = "aws ec2 stop-instances " \
              + " --instance-ids %s " % (instance_id)
    result = local(command, capture=True)
    return result


def terminate_instances(instance_id):
    command = "aws ec2 terminate-instances " \
              + " --instance-ids %s " % (instance_id)
    result = local(command, capture=True)
    return result


def get_instance_id(environment, role, application):
    name = '-'.join([environment, role, application])
    command = "aws ec2 describe-instances " \
              + " --filters " \
              + " 'Name=tag-key,Values=Name' " \
              + " 'Name=tag-value,Values=%s' " % (name) \
              + " 'Name=instance-state-name,Values=running,stopped' " \
              + " | jq -r '.Reservations[].Instances[].InstanceId' "
    result = local(command, capture=True)
    return result
