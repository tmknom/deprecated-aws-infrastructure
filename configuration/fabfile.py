# -*- encoding:utf-8 -*-
#
# サーバコンフィギュレーション実行スクリプト
#
# 実行例１ : fab base -H 127.0.0.1
# 実行例２ : fab spec_base -H 127.0.0.1
#
#####################################################################

from fabric.api import *

BASE_ROLE = 'base'
RAILS_ROLE = 'rails'

EC2_USER = 'ec2-user'
DEFAULT_SSH_PORT = '22'


@task
def base():
    '''base コンフィギュレーション（初回）'''
    execute_itamae(
        BASE_ROLE,
        EC2_USER,
        DEFAULT_SSH_PORT,
        get_env('SSH_INITIALIZE_KEY_PATH')
    )


@task
def rails():
    '''rails コンフィギュレーション'''
    itamae(RAILS_ROLE)


# base は初回実行時とSSHのポートが異なるため、特別に実装している（base以外は不要）
@task
def re_base():
    '''base コンフィギュレーション（２回目以降）'''
    itamae(BASE_ROLE)


@task
def spec_base():
    '''base のServerspec実行'''
    serverspec(BASE_ROLE)


@task
def spec_rails():
    '''rails のServerspec実行'''
    serverspec(RAILS_ROLE)


def itamae(role):
    execute_itamae(
        role,
        EC2_USER,
        get_env('SSH_PORT'),
        get_env('SSH_INITIALIZE_KEY_PATH')
    )


def execute_itamae(role, user_name, ssh_port, ssh_key_path):
    command = "time bundle exec itamae ssh " \
              + " roles/%s.rb " % (role) \
              + " -u %s " % (user_name) \
              + " -p %s " % (ssh_port) \
              + " -i %s " % (ssh_key_path) \
              + " -h %s " % (env.hosts[0])
    local(command)


def serverspec(role):
    execute_serverspec(
        role,
        EC2_USER,
        get_env('SSH_PORT'),
        get_env('SSH_INITIALIZE_KEY_PATH')
    )


def execute_serverspec(role, user_name, ssh_port, ssh_key_path):
    command = " ROLE=%s " % (role) \
              + " USER=%s " % (user_name) \
              + " PORT=%s " % (ssh_port) \
              + " KEY_PATH=%s " % (ssh_key_path) \
              + " HOST_IP=%s " % (env.hosts[0]) \
              + " SUDO_PASSWORD='' " \
              + " SPEC_OPTS='--color --format documentation' " \
              + " bundle exec rake spec"
    local(command)


def get_env(key):
    command = "echo $%s" % (key)
    result = local(command, capture=True)
    return result
