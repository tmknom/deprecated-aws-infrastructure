# -*- encoding:utf-8 -*-

from fabric.api import *


@task
def change_password(db_instance_identifier):
    '''RDSのパスワード変更'''
    db_password = get_env('DATABASE_MASTER_USER_PASSWORD')
    execute_modify_password(db_instance_identifier, db_password)


def execute_modify_password(db_instance_identifier, db_password):
    command = ' aws rds modify-db-instance' \
              + ' --db-instance-identifier %s' % (db_instance_identifier) \
              + ' --master-user-password "%s"' % (db_password)
    with hide('running'):
        local(command)


def get_env(key_name):
    command = 'echo $%s' % (key_name)
    with hide('stdout'):
        result = local(command, capture=True)
    return result
