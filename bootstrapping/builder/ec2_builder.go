package builder

import (
	svc "github.com/aws/aws-sdk-go/service/ec2"

	"../ec2"
)

const SUBNET_NAME = "Testing-Tokyo-Public-Subnet-1"
const SSH_SECURITY_GROUP_NAME = "Testing-SSH-SecurityGroup"
const INITIALIZE_SECURITY_GROUP_NAME = "Testing-Initialize-SecurityGroup"
const INITIALIZE_KEY_NAME = "initialize"

type Ec2Builder struct {
	Ec2Service *svc.EC2
}

func (eb Ec2Builder) Build(imageId string) (ec2.InstanceId, ec2.PublicIpAddress, error) {
	param := ec2.Ec2InstanceParam{
		ImageId:                   imageId,
		KeyName:                   eb.getKeyName(),
		SubnetId:                  eb.getSubnetId(),
		SshSecurityGroupId:        eb.getSshSecurityGroupId(),
		InitializeSecurityGroupId: eb.getInitializeSecurityGroupId(),
	}

	ec2Instance := ec2.Ec2Instance{Ec2Api: *eb.Ec2Service}
	return ec2Instance.Create(param)
}

func (eb Ec2Builder) Destroy(instanceId ec2.InstanceId) {
	ec2Instance := ec2.Ec2Instance{Ec2Api: *eb.Ec2Service}
	ec2Instance.Terminate(instanceId)
}

func (eb Ec2Builder) getKeyName() string {
	return INITIALIZE_KEY_NAME
}

func (eb Ec2Builder) getSubnetId() string {
	return ec2.Subnet{Ec2Api: *eb.Ec2Service}.GetSubnetId(SUBNET_NAME)
}

func (eb Ec2Builder) getSshSecurityGroupId() string {
	return ec2.SecurityGroup{Ec2Api: *eb.Ec2Service}.GetSecurityGroupId(SSH_SECURITY_GROUP_NAME)
}

func (eb Ec2Builder) getInitializeSecurityGroupId() string {
	return ec2.SecurityGroup{Ec2Api: *eb.Ec2Service}.GetSecurityGroupId(INITIALIZE_SECURITY_GROUP_NAME)
}
