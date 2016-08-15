# -*- encoding:utf-8 -*-

from fabric.api import *
import boto3


# 暗号化済みSlackトークン
SLACK_ENCRYPTED_TOKEN = 'slack/encrypted_token'

# 暗号化済みGitHubトークン
GITHUB_ENCRYPTED_TOKEN = 'github/encrypted_token'

# 暗号化マスターキー
ENCRYPTION_DATA_MASTER_KEY_ID = 'ENCRYPTION_DATA_MASTER_KEY_ID'
# 暗号化データ保存バケット
ENCRYPTION_DATA_BUCKET = 'ENCRYPTION_DATA_BUCKET'


def update_slack_token(slack_token):
    encrypt_and_upload_s3(slack_token, SLACK_ENCRYPTED_TOKEN)


def update_github_token(github_token):
    encrypt_and_upload_s3(github_token, GITHUB_ENCRYPTED_TOKEN)


def encrypt_and_upload_s3(plaintext, object_name):
    encrypted_data = encrypt(plaintext)
    upload_s3(object_name, encrypted_data)


def encrypt(plaintext):
    key_id = get_env(ENCRYPTION_DATA_MASTER_KEY_ID)
    return kms_encrypt(plaintext, key_id)


def kms_encrypt(plaintext, key_id):
    region = get_default_region()
    command = "aws kms encrypt " \
            + " --region %s " % (region) \
            + " --plaintext %s " % (plaintext) \
            + " --key-id %s " % (key_id) \
            + " --query CiphertextBlob --output text " \
            + " | base64 --decode "
    result = local(command, capture=True)
    return result


def upload_s3(object_name, data):
    bucket_name = get_env(ENCRYPTION_DATA_BUCKET)
    put_s3(bucket_name, object_name, data)


def put_s3(bucket_name, object_name, data):
    s3 = boto3.resource('s3')
    s3.Object(bucket_name, object_name).put(Body=data)


def get_default_region():
    command = 'aws configure get region'
    result = local(command, capture=True)
    return result


def get_env(env_name):
    return local('echo $%s' % (env_name), capture=True)
