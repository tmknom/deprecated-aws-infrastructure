# -*- encoding:utf-8 -*-

from fabric.api import *

ENVIRONMENT_PRODUCTION = 'Production'
ENVIRONMENT_ADMINISTRATION = 'Administration'

ROLE_SSH = 'SSH'
ROLE_INITIALIZATION = 'Initialization'

DEFAULT_SSH_PORT = '22'


def authorize():
    current_ip_address = get_current_ip_address()
    authorize_security_group(current_ip_address, ENVIRONMENT_ADMINISTRATION, ROLE_INITIALIZATION)
    authorize_security_group(current_ip_address, ENVIRONMENT_ADMINISTRATION, ROLE_SSH)
    authorize_security_group(current_ip_address, ENVIRONMENT_PRODUCTION, ROLE_SSH)


def authorize_security_group(current_ip_address, environment, role):
    security_group_id = get_security_group_id(environment, role)
    ssh_port = get_ssh_port(role)
    authorize_security_group_ingress(current_ip_address, security_group_id, ssh_port)


def authorize_security_group_ingress(current_ip_address, security_group_id, ssh_port):
    command = "aws ec2 authorize-security-group-ingress " \
              + " --protocol tcp " \
              + " --group-id %s " % (security_group_id) \
              + " --port %s " % (ssh_port) \
              + " --cidr %s/32 " % (current_ip_address)
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


def get_ssh_port(role):
    if role == ROLE_INITIALIZATION:
        return DEFAULT_SSH_PORT
    return get_ssh_port_env()


def get_ssh_port_env():
    command = 'echo $SSH_PORT'
    result = local(command, capture=True)
    return result


def get_current_ip_address():
    import urllib2
    return urllib2.urlopen('http://inet-ip.info/ip').read()
