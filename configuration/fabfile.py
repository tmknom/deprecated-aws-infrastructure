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
TECH_NEWS_ROLE = 'tech_news'
VAGRANT_ROLE = 'vagrant'

EC2_USER = 'ec2-user'
VAGRANT_USER = 'vagrant'

DEFAULT_SSH_PORT = '22'
VAGRANT_IP_ADDRESS = '192.168.100.11'


@task
def itamae_base():
    '''base コンフィギュレーション（初回） [-H <ip_address>]'''
    execute_itamae(
        BASE_ROLE,
        EC2_USER,
        DEFAULT_SSH_PORT,
        get_env('SSH_INITIALIZE_KEY_PATH')
    )


@task
def itamae_rails():
    '''rails コンフィギュレーション [-H <ip_address>]'''
    itamae(RAILS_ROLE)


@task
def itamae_tech_news():
    '''tech_news コンフィギュレーション [-H <ip_address>]'''
    itamae(TECH_NEWS_ROLE)


# base は初回実行時とSSHのポートが異なるため、特別に実装している（base以外は不要）
@task
def itamae_re_base():
    '''base コンフィギュレーション（２回目以降） [-H <ip_address>]'''
    itamae(BASE_ROLE)


@task
def itamae_vagrant():
    '''vagrant コンフィギュレーション'''
    env.hosts = [VAGRANT_IP_ADDRESS]
    private_key = get_vagrant_private_key()
    execute_itamae(
        VAGRANT_ROLE,
        VAGRANT_USER,
        DEFAULT_SSH_PORT,
        private_key
    )


def get_vagrant_private_key():
    command = "vagrant ssh-config | grep IdentityFile | cut -d ' ' -f 4- | tr -d '\"'"
    result = local(command, capture=True)
    return result


@task
def spec_base():
    '''base のServerspec実行 [-H <ip_address>]'''
    serverspec(BASE_ROLE)


@task
def spec_rails():
    '''rails のServerspec実行 [-H <ip_address>]'''
    serverspec(RAILS_ROLE)


@task
def spec_tech_news():
    '''tech_news のServerspec実行 [-H <ip_address>]'''
    serverspec(TECH_NEWS_ROLE)


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
    with lcd(get_current_dir()):
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
    with lcd(get_current_dir()):
        local(command)


def get_env(key):
    command = "echo $%s" % (key)
    result = local(command, capture=True)
    return result


def get_current_dir():
    import os
    return os.path.abspath(os.path.dirname(__file__))
