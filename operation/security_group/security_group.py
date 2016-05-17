# -*- encoding:utf-8 -*-

import json
from fabric.api import *

ENVIRONMENT_PRODUCTION = 'Production'
ENVIRONMENT_ADMINISTRATION = 'Administration'

ROLE_SSH = 'SSH'
ROLE_RAILS = 'Rails'
ROLE_INTERNAL_RAILS = 'InternalRails'
ROLE_INITIALIZATION = 'Initialization'

DEFAULT_SSH_PORT = '22'
HTTP_PORT = '80'

LOCALHOST_CIDR_BLOCK = '127.0.0.1/32'


def authorize_http():
    revoke_http()
    current_ip_address = get_current_ip_address()
    authorize_security_group(current_ip_address, ENVIRONMENT_PRODUCTION, ROLE_INTERNAL_RAILS)


def revoke_http():
    revoke_security_group(ENVIRONMENT_PRODUCTION, ROLE_INTERNAL_RAILS)


def authorize():
    revoke()
    current_ip_address = get_current_ip_address()
    authorize_security_group(current_ip_address, ENVIRONMENT_ADMINISTRATION, ROLE_INITIALIZATION)
    authorize_security_group(current_ip_address, ENVIRONMENT_ADMINISTRATION, ROLE_RAILS)
    authorize_security_group(current_ip_address, ENVIRONMENT_ADMINISTRATION, ROLE_SSH)
    authorize_security_group(current_ip_address, ENVIRONMENT_PRODUCTION, ROLE_INTERNAL_RAILS)
    authorize_security_group(current_ip_address, ENVIRONMENT_PRODUCTION, ROLE_SSH)


def revoke():
    revoke_security_group(ENVIRONMENT_ADMINISTRATION, ROLE_INITIALIZATION)
    revoke_security_group(ENVIRONMENT_ADMINISTRATION, ROLE_RAILS)
    revoke_security_group(ENVIRONMENT_ADMINISTRATION, ROLE_SSH)
    revoke_security_group(ENVIRONMENT_PRODUCTION, ROLE_INTERNAL_RAILS)
    revoke_security_group(ENVIRONMENT_PRODUCTION, ROLE_SSH)


def authorize_security_group(current_ip_address, environment, role):
    security_group_id = get_security_group_id(environment, role)
    port = get_port(role)
    authorize_security_group_ingress(current_ip_address, security_group_id, port)


def revoke_security_group(environment, role):
    security_group_id = get_security_group_id(environment, role)
    port = get_port(role)
    cidr_blocks = get_cidr_blocks(security_group_id)
    for cidr_block in cidr_blocks:
        if cidr_block != LOCALHOST_CIDR_BLOCK:
            revoke_security_group_ingress(cidr_block, security_group_id, port)


def authorize_security_group_ingress(current_ip_address, security_group_id, port):
    command = "aws ec2 authorize-security-group-ingress " \
              + " --protocol tcp " \
              + " --group-id %s " % (security_group_id) \
              + " --port %s " % (port) \
              + " --cidr %s/32 " % (current_ip_address)
    result = local(command, capture=True)
    return result


def revoke_security_group_ingress(cidr_block, security_group_id, port):
    command = "aws ec2 revoke-security-group-ingress " \
              + " --protocol tcp " \
              + " --group-id %s " % (security_group_id) \
              + " --port %s " % (port) \
              + " --cidr %s " % (cidr_block)
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


def get_cidr_blocks(security_group_id):
    command = "aws ec2 describe-security-groups " \
              + " --group-ids %s " % (security_group_id) \
              + " | jq '.SecurityGroups[0].IpPermissions[0].IpRanges | map(.CidrIp)' "
    result = local(command, capture=True)
    return json.loads(result)


def get_port(role):
    if role == ROLE_INITIALIZATION:
        return DEFAULT_SSH_PORT
    elif role == ROLE_RAILS:
        return HTTP_PORT
    elif role == ROLE_INTERNAL_RAILS:
        return HTTP_PORT
    else:
        return get_ssh_port_env()


def get_ssh_port_env():
    command = 'echo $SSH_PORT'
    result = local(command, capture=True)
    return result


def get_current_ip_address():
    import urllib2
    try:
        return urllib2.urlopen('http://inet-ip.info/ip').read()
    except:
        import json
        return json.loads(urllib2.urlopen('http://httpbin.org/ip').read())['origin']
