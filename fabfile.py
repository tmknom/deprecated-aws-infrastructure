# -*- encoding:utf-8 -*-
#
# 管理用スクリプト
#
#####################################################################

from fabric.api import *

from operation.fabfile import prepare
from operation.fabfile import clear
from operation.fabfile import sg_authorize
from operation.fabfile import sg_revoke
from operation.fabfile import sg_authorize_http
from operation.fabfile import ec2_list
from operation.fabfile import ec2_build_testing
from operation.fabfile import ec2_re_build_testing
