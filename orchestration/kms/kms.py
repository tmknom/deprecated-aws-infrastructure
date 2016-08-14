# -*- encoding:utf-8 -*-
#
# KMS設定用のヘルパースクリプト
#
#####################################################################

from fabric.api import *

ENCRYPTION_DATA_MASTER_KEY_PARAMS = {
    'env_key_id'  : 'ENCRYPTION_DATA_MASTER_KEY_ID',
    'alias'       : 'alias/encryption-data', # エイリアス（KMSの仕様上、接頭辞「alias/」は必須）
    'description' : 'Default master key that protects my encryption data',
    'policy_file' : 'encryption_data_policy.json',
}

# ポリシー名（2016年8月現在のKMSの仕様では「default」のみ指定可能）
DEFAULT_POLICY_NAME = 'default'


def build_kms(params):
    key_id = get_env(params['env_key_id'])
    define_alias(key_id, params['alias'])
    define_description(key_id, params['description'])
    define_policy(key_id, params['policy_file'], DEFAULT_POLICY_NAME)


def define_alias(key_id, new_alias):
    old_alias = describe_alias(key_id)
    print(old_alias)
    if new_alias == old_alias:
        return

    delete_alias(old_alias)
    create_alias(key_id, new_alias)


def describe_alias(key_id):
    region = get_default_region()
    command = 'aws kms list-aliases ' \
            + ' --region ' + region \
            + ' | jq -r \' ' \
            + ' .Aliases | ' \
            + ' map(select(.TargetKeyId == "' + key_id + '")) | ' \
            + ' .[0].AliasName\' '
    alias = local(command, capture=True)
    return alias

def create_alias(key_id, alias):
    region = get_default_region()
    command = 'aws kms create-alias ' \
            + ' --region ' + region \
            + ' --target-key-id ' + key_id \
            + ' --alias-name ' + alias
    local(command)

def delete_alias(alias):
    if alias == 'null':
        return

    region = get_default_region()
    command = 'aws kms delete-alias ' \
            + ' --region ' + region \
            + ' --alias-name ' + alias
    local(command)


def define_description(key_id,description):
    region = get_default_region()
    command = 'aws kms update-key-description ' \
            + ' --region ' + region \
            + ' --key-id ' + key_id \
            + ' --description "' + description + '"'
    local(command)


def define_policy(key_id, policy_file, policy_name):
    region = get_default_region()
    policy_file_path = 'file:///' + get_current_dir() + '/' + policy_file
    command = 'aws kms put-key-policy ' \
            + ' --region ' + region \
            + ' --key-id ' + key_id \
            + ' --policy-name ' + policy_name \
            + ' --policy ' + policy_file_path
    local(command)


def get_default_region():
    command = 'aws configure get region'
    result = local(command, capture=True)
    return result

def get_env(key_name):
    command = 'echo $%s' % (key_name)
    with hide('stdout'):
        result = local(command, capture=True)
    return result

def get_current_dir():
    import os
    return os.path.abspath(os.path.dirname(__file__))
