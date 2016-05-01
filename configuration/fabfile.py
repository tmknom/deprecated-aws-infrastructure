# -*- encoding:utf-8 -*-
#
# サーバコンフィギュレーション実行スクリプト
#
# 実行例 : fab rails -H 127.0.0.1
#
#####################################################################

from fabric.api import *

EC2_USER = 'ec2-user'
DEFAULT_SSH_PORT = '22'


@task
def base():
    '''base コンフィギュレーション（初回）'''
    itamae(
        'base',
        EC2_USER,
        DEFAULT_SSH_PORT,
        get_env('SSH_INITIALIZE_KEY_PATH')
    )


@task
def rails():
    '''rails コンフィギュレーション'''
    itamae(
        'rails',
        EC2_USER,
        get_env('SSH_PORT'),
        get_env('SSH_INITIALIZE_KEY_PATH')
    )


# base は初回実行時とSSHのポートが異なるため、特別に実装している（base以外は不要）
@task
def re_base():
    '''base コンフィギュレーション（２回目以降）'''
    itamae(
        'base',
        EC2_USER,
        get_env('SSH_PORT'),
        get_env('SSH_INITIALIZE_KEY_PATH')
    )


def get_env(key):
    command = "echo $%s" % (key)
    result = local(command, capture=True)
    return result


def itamae(role, ssh_user_name, ssh_port, ssh_key_path):
    command = "time bundle exec itamae ssh " \
              + " roles/%s.rb " % (role) \
              + " -u %s " % (ssh_user_name) \
              + " -p %s " % (ssh_port) \
              + " -i %s " % (ssh_key_path) \
              + " -h %s " % (env.hosts[0])
    local(command)
