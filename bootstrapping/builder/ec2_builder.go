package builder

import (
	svc "github.com/aws/aws-sdk-go/service/ec2"

	"../ec2"
)

const SUBNET_NAME = "Administration-Public-Subnet-0"
const SSH_SECURITY_GROUP_NAME = "Administration-SSH-SecurityGroup"
const INITIALIZATION_SECURITY_GROUP_NAME = "Administration-Initialization-SecurityGroup"
const INITIALIZATION_KEY_NAME = "initialization"

type Ec2Builder struct {
	Ec2Service *svc.EC2
}

func (eb Ec2Builder) Build(imageId string) (ec2.InstanceId, ec2.PublicIpAddress, error) {
	param := ec2.Ec2InstanceParam{
		ImageId:                       imageId,
		KeyName:                       eb.getKeyName(),
		SubnetId:                      eb.getSubnetId(),
		SshSecurityGroupId:            eb.getSshSecurityGroupId(),
		InitializationSecurityGroupId: eb.getInitializationSecurityGroupId(),
	}

	ec2Instance := ec2.Ec2Instance{Ec2Api: *eb.Ec2Service}
	return ec2Instance.Create(param)
}

func (eb Ec2Builder) Destroy(instanceId ec2.InstanceId) {
	ec2Instance := ec2.Ec2Instance{Ec2Api: *eb.Ec2Service}
	ec2Instance.Terminate(instanceId)
}

func (eb Ec2Builder) getKeyName() string {
	return INITIALIZATION_KEY_NAME
}

func (eb Ec2Builder) getSubnetId() string {
	return ec2.Subnet{Ec2Api: *eb.Ec2Service}.GetSubnetId(SUBNET_NAME)
}

func (eb Ec2Builder) getSshSecurityGroupId() string {
	return ec2.SecurityGroup{Ec2Api: *eb.Ec2Service}.GetSecurityGroupId(SSH_SECURITY_GROUP_NAME)
}

func (eb Ec2Builder) getInitializationSecurityGroupId() string {
	return ec2.SecurityGroup{Ec2Api: *eb.Ec2Service}.GetSecurityGroupId(INITIALIZATION_SECURITY_GROUP_NAME)
}
