package ec2

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
)

const BASE_INSTANCE_TYPE = "t2.micro"
const BASE_VOLUME_SIZE = 8

type Ec2Instance struct {
	Ec2Api ec2.EC2
}

type Ec2InstanceParam struct {
	ImageId                   string
	KeyName                   string
	SubnetId                  string
	SshSecurityGroupId        string
	InitializeSecurityGroupId string
}

func (ei Ec2Instance) Create(param Ec2InstanceParam) (*ec2.Instance, error) {
	fmt.Println("Launching a source AWS instance...")

	input := ei.createRunInstancesInput(param)
	resp, err := ei.runInstances(input)
	instance := resp.Instances[0]

	fmt.Println("Waiting for instance to become ready...")
	ei.wait(instance)

	return instance, err
}

func (ei Ec2Instance) runInstances(input *ec2.RunInstancesInput) (*ec2.Reservation, error) {
	return ei.Ec2Api.RunInstances(input)
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

func (ei Ec2Instance) wait(instance *ec2.Instance) {
	waitInput := &ec2.DescribeInstanceStatusInput{
		InstanceIds: []*string{aws.String(*(instance.InstanceId))},
	}
	ei.Ec2Api.WaitUntilInstanceStatusOk(waitInput)
}
