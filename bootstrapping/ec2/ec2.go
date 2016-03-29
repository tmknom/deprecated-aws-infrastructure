package ec2

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/ec2/ec2iface"
)

const BASE_INSTANCE_TYPE = "t2.micro"
const BASE_VOLUME_SIZE = 8

type Ec2Instance struct {
	Ec2Api ec2iface.EC2API
}

type Ec2InstanceParam struct {
	ImageId                   string
	KeyName                   string
	SubnetId                  string
	SshSecurityGroupId        string
	InitializeSecurityGroupId string
}

func (ei Ec2Instance) Create(param Ec2InstanceParam) (*ec2.Instance, error) {
	input := ei.createRunInstancesInput(param)
	apiResult, err := ei.Ec2Api.RunInstances(input)
	return apiResult.Instances[0], err
}

func (ei Ec2Instance) createRunInstancesInput(param Ec2InstanceParam) *ec2.RunInstancesInput {
	runInstancesInput := &ec2.RunInstancesInput{
		ImageId:      aws.String(param.ImageId),
		MaxCount:     aws.Int64(1),
		MinCount:     aws.Int64(1),
		InstanceType: aws.String(BASE_INSTANCE_TYPE),
		BlockDeviceMappings: []*ec2.BlockDeviceMapping{
			{
				DeviceName: aws.String("/dev/xvda"),
				Ebs: &ec2.EbsBlockDevice{
					DeleteOnTermination: aws.Bool(true),
					VolumeSize:          aws.Int64(int64(BASE_VOLUME_SIZE)),
					VolumeType:          aws.String("gp2"),
				},
			},
		},
		NetworkInterfaces: []*ec2.InstanceNetworkInterfaceSpecification{
			{
				AssociatePublicIpAddress: aws.Bool(true),
				DeleteOnTermination:      aws.Bool(true),
				DeviceIndex:              aws.Int64(0),
				SubnetId:                 aws.String(param.SubnetId),
				Groups: []*string{
					aws.String(param.InitializeSecurityGroupId),
					aws.String(param.SshSecurityGroupId),
				},
			},
		},
	}

	if param.KeyName != "" {
		runInstancesInput.KeyName = aws.String(param.KeyName)
	}

	return runInstancesInput
}
