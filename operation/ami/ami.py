# -*- encoding:utf-8 -*-

import json
from fabric.api import *

ROLE_WONDERFUL_WORLD = 'WonderfulWorld'

SOURCE_REGION = 'ap-northeast-1'
US_REGION = 'us-west-1'


def sync_wonderful_world():
    sync(ROLE_WONDERFUL_WORLD, US_REGION)


def sync(role, target_region):
    ami = get_ami_id(role)
    new_ami_id = copy_ami(ami['AmiId'], ami['Name'], target_region)
    create_instance_tag(ami['Tags'], new_ami_id, target_region)


def get_ami_id(role):
    command = "aws ec2 describe-images " \
              + " --region %s " % (SOURCE_REGION) \
              + " --filters " \
              + " 'Name=tag-key,Values=Role' " \
              + " 'Name=tag-value,Values=%s' " % (role) \
              + " | jq -r '.Images | sort_by(.CreationDate) | reverse | .[0] | {AmiId: .ImageId, Name: .Name, Tags: .Tags}' "
    result = local(command, capture=True)
    return json.loads(result)


def copy_ami(ami_id, ami_name, target_region):
    command = "aws ec2 copy-image " \
              + " --region %s " % (target_region) \
              + " --source-region %s " % (SOURCE_REGION) \
              + " --source-image-id %s " % (ami_id) \
              + " --name %s " % (ami_name) \
              + " | jq -r '.ImageId' "
    result = local(command, capture=True)
    return result


def create_instance_tag(tags, ami_id, target_region):
    for tag in tags:
        create_tags(target_region, ami_id, tag['Key'], tag['Value'])


def create_tags(target_region, ami_id, tag_key, tag_value):
    command = "aws ec2 create-tags " \
              + " --region %s " % (target_region) \
              + " --resources %s " % (ami_id) \
              + " --tags Key=%s,Value=%s " % (tag_key, tag_value)
    local(command)
