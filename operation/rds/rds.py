# -*- encoding:utf-8 -*-

import base64
import json

from fabric.api import *

ENVIRONMENT_ADMINISTRATION = 'Administration'
ROLE_MYSQL = 'MySQL'

ADMINISTRATION_DB_INSTANCE_IDENTIFIER = 'administration-mysql'
ADMINISTRATION_DB_SUBNET_GROUP_NAME = 'administration-mysql-db-subnet-group'
ADMINISTRATION_DB_PARAMETER_GROUP_NAME = 'administration-mysql-db-parameter-group'

INSTANCE_TYPE = 'db.t2.micro'
AVAILABILITY_ZONE = 'ap-northeast-1c'


def start_administration():
    start(ADMINISTRATION_DB_INSTANCE_IDENTIFIER)


def stop_administration():
    stop(ADMINISTRATION_DB_INSTANCE_IDENTIFIER)


def start(db_identifier):
    restore(db_identifier)
    modify(db_identifier)


def stop(db_identifier):
    db_snapshot_identifier = create_final_db_snapshot_identifier(db_identifier)
    delete_db_instance(db_identifier, db_snapshot_identifier)


def restore(db_identifier):
    db_snapshot_identifier = get_last_snapshot_identifier(db_identifier)
    restore_db_instance_from_db_snapshot(db_identifier, db_snapshot_identifier,
                                         ADMINISTRATION_DB_SUBNET_GROUP_NAME, AVAILABILITY_ZONE, INSTANCE_TYPE)
    wait(db_identifier)
    delete_db_snapshot(db_snapshot_identifier)


def modify(db_identifier):
    security_group_id = get_security_group_id(ENVIRONMENT_ADMINISTRATION, ROLE_MYSQL)
    modify_db_instance(db_identifier, security_group_id, ADMINISTRATION_DB_PARAMETER_GROUP_NAME)
    reboot_db_instance(db_identifier)


def restore_db_instance_from_db_snapshot(db_identifier, db_snapshot_identifier, db_subnet_group_name,
                                         availability_zone, db_instance_class):
    command = "aws rds restore-db-instance-from-db-snapshot " \
              + " --db-instance-identifier %s " % (db_identifier) \
              + " --db-subnet-group-name %s " % (db_subnet_group_name) \
              + " --db-snapshot-identifier %s " % (db_snapshot_identifier) \
              + " --availability-zone %s " % (availability_zone) \
              + " --db-instance-class %s " % (db_instance_class) \
              + " --storage-type gp2 " \
              + " --no-publicly-accessible " \
              + " --no-multi-az "
    result = local(command, capture=True)
    return result


def wait(db_identifier):
    command = "aws rds wait db-instance-available " \
              + " --db-instance-identifier %s " % (db_identifier)
    local(command)


def delete_db_snapshot(db_snapshot_identifier):
    command = "aws rds delete-db-snapshot " \
              + " --db-snapshot-identifier %s " % (db_snapshot_identifier)
    result = local(command, capture=True)
    return result


def modify_db_instance(db_identifier, security_group_id, db_parameter_group_name):
    command = "aws rds modify-db-instance " \
              + " --db-instance-identifier %s " % (db_identifier) \
              + " --vpc-security-group-ids %s " % (security_group_id) \
              + " --db-parameter-group-name %s " % (db_parameter_group_name) \
              + " --copy-tags-to-snapshot " \
              + " --apply-immediately "
    result = local(command, capture=True)
    return result


def reboot_db_instance(db_identifier):
    command = "aws rds reboot-db-instance " \
              + " --db-instance-identifier %s " % (db_identifier)
    result = local(command, capture=True)
    return result


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


def get_last_snapshot_identifier(db_identifier):
    command = "aws rds describe-db-snapshots " \
              + " --db-instance-identifier %s " % (db_identifier) \
              + " | jq -r '.DBSnapshots | sort_by(.SnapshotCreateTime) | reverse | .[0].DBSnapshotIdentifier' "
    result = local(command, capture=True)
    return result


def delete_db_instance(db_identifier, db_snapshot_identifier):
    command = "aws rds delete-db-instance " \
              + " --db-instance-identifier %s " % (db_identifier) \
              + " --final-db-snapshot-identifier %s " % (db_snapshot_identifier) \
              + " --no-skip-final-snapshot "
    result = local(command, capture=True)
    return result


def create_final_db_snapshot_identifier(db_identifier):
    import datetime
    return db_identifier + '-' + datetime.datetime.now().strftime("%Y-%m-%d-%H-%M")


def get_rds_status(db_identifier):
    command = "aws rds describe-db-instances " \
              + " --db-instance-identifier %s " % (db_identifier) \
              + " | jq -r '.DBInstances[].DBInstanceStatus' "
    result = local(command, capture=True)
    return result
