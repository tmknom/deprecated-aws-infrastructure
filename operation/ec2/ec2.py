# -*- encoding:utf-8 -*-

import base64
import json

from fabric.api import *

ENVIRONMENT_TESTING = 'Testing'
ENVIRONMENT_PRODUCTION = 'Production'
ENVIRONMENT_ADMINISTRATION = 'Administration'

ROLE_SSH = 'SSH'
ROLE_RAILS = 'Rails'
ROLE_MYSQL_CLIENT = 'MySQLClient'
ROLE_TECH_NEWS = 'TechNews'
ROLE_WONDERFUL_WORLD = 'WonderfulWorld'

NETWORK_PUBLIC = 'Public'

APPLICATION_TECH_NEWS = 'tech-news'
APPLICATION_WONDERFUL_WORLD = 'wonderful-world'


def list():
    command = "aws ec2 describe-instances " \
              + " | jq '.Reservations[].Instances[] " \
              + " | {Name: (.Tags[] | select(.Key==\"Name\").Value), PublicIpAddress}' "
    local(command)


def re_build_tech_news():
    remove_tech_news()
    build_tech_news()


def build_tech_news():
    build(APPLICATION_TECH_NEWS, ROLE_TECH_NEWS)


def start_tech_news():
    start(APPLICATION_TECH_NEWS)


def stop_tech_news():
    stop(APPLICATION_TECH_NEWS)


def remove_tech_news():
    remove(APPLICATION_TECH_NEWS)


def re_build_wonderful_world():
    remove_wonderful_world()
    build_wonderful_world()


def build_wonderful_world():
    build(APPLICATION_WONDERFUL_WORLD, ROLE_WONDERFUL_WORLD)


def start_wonderful_world():
    start(APPLICATION_WONDERFUL_WORLD)


def stop_wonderful_world():
    stop(APPLICATION_WONDERFUL_WORLD)


def remove_wonderful_world():
    remove(APPLICATION_WONDERFUL_WORLD)


def build(application, role):
    instance_id = create_instance(role)
    create_instance_tag(instance_id, application)


def start(application):
    instance_id = get_instance_id(ENVIRONMENT_TESTING, ROLE_RAILS, application)
    start_instances(instance_id)


def stop(application):
    instance_id = get_instance_id(ENVIRONMENT_TESTING, ROLE_RAILS, application)
    stop_instances(instance_id)


def remove(application):
    instance_id = get_instance_id(ENVIRONMENT_TESTING, ROLE_RAILS, application)
    terminate_instances(instance_id)


def create_instance(role):
    ami_id = get_ami_id(role)
    subnet_id = get_subnet_id(ENVIRONMENT_ADMINISTRATION, NETWORK_PUBLIC)
    security_group_id = get_security_group_id(ENVIRONMENT_ADMINISTRATION, ROLE_RAILS)
    ssh_security_group_id = get_security_group_id(ENVIRONMENT_ADMINISTRATION, ROLE_SSH)
    rds_security_group_id = get_security_group_id(ENVIRONMENT_ADMINISTRATION, ROLE_MYSQL_CLIENT)
    user_data = create_user_data()
    return run_instances(ami_id, subnet_id, security_group_id, ssh_security_group_id, rds_security_group_id, user_data)


def create_instance_tag(instance_id, application):
    create_tags(instance_id, 'Application', application)
    create_tags(instance_id, 'DeploymentGroup', '-'.join([ENVIRONMENT_TESTING, application]).lower())
    create_tags(instance_id, 'Environment', ENVIRONMENT_TESTING)
    create_tags(instance_id, 'Name', '-'.join([ENVIRONMENT_TESTING, ROLE_RAILS, application]))
    create_tags(instance_id, 'Roles', ROLE_RAILS)


def run_instances(ami_id, subnet_id, security_group_id, ssh_security_group_id, rds_security_group_id, user_data):
    command = "aws ec2 run-instances  " \
              + " --image-id %s " % (ami_id) \
              + " --subnet-id %s " % (subnet_id) \
              + " --security-group-ids %s %s %s " % (security_group_id, ssh_security_group_id, rds_security_group_id) \
              + " --user-data %s " % (user_data) \
              + " --instance-type t2.micro " \
              + " --iam-instance-profile Name=RailsInstanceProfile " \
              + " --associate-public-ip-address " \
              + " --block-device-mappings " \
              + ' \'[{"DeviceName":"/dev/xvda", ' \
              + ' "Ebs":{"VolumeSize":8,"DeleteOnTermination":true,"VolumeType": "gp2"}}]\' ' \
              + " | jq -r '.Instances[].InstanceId' "
    result = local(command, capture=True)
    return result


def create_user_data():
    user_home = get_local_env('APPLICATION_USER_HOME')
    database_host = get_local_env('DATABASE_HOST_ADMINISTRATION')
    shell = "#!/bin/bash\n" \
            + "echo 'export DATABASE_HOST=%s' >> %s/.bashrc" % (database_host, user_home)
    base64_shell = base64.b64encode(shell)
    return base64_shell


def get_subnet_id(environment, network):
    command = "aws ec2 describe-subnets " \
              + " --filters " \
              + " 'Name=tag-key,Values=Environment' " \
              + " 'Name=tag-value,Values=%s' " % (environment) \
              + " 'Name=tag-key,Values=Network' " \
              + " 'Name=tag-value,Values=%s' " % (network) \
              + " | jq '.Subnets' | jq 'map(.SubnetId)' "
    result = local(command, capture=True)
    return json.loads(result)[0]


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
              + " | jq -r '.Images | sort_by(.CreationDate) | reverse | .[0].ImageId' "
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


def get_local_env(env_name):
    return local('echo $%s' % (env_name), capture=True)
