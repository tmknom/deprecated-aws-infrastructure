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
	waitInput := ei.createDescribeInstanceStatusInput(instance)
	ei.WaitUntilInstanceStatusOk(waitInput)

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

func (ei Ec2Instance) WaitUntilInstanceStatusOk(input *ec2.DescribeInstanceStatusInput) {
	ei.Ec2Api.WaitUntilInstanceStatusOk(input)
}

func (ei Ec2Instance) createDescribeInstanceStatusInput(instance *ec2.Instance) *ec2.DescribeInstanceStatusInput {
	return &ec2.DescribeInstanceStatusInput{
		InstanceIds: []*string{aws.String(*(instance.InstanceId))},
	}
}

func (ei Ec2Instance) Stop(instance *ec2.Instance) {
	fmt.Println("Stopping the source instance...")
	input := ei.createStopInstancesInput(instance)
	ei.stopInstances(input)

	fmt.Println("Waiting for the instance to stop...")
	waitInput := ei.createDescribeInstancesInput(instance)
	ei.waitUntilInstanceStopped(waitInput)
}

func (ei Ec2Instance) stopInstances(input *ec2.StopInstancesInput) (*ec2.StopInstancesOutput, error) {
	return ei.Ec2Api.StopInstances(input)
}

func (ei Ec2Instance) createStopInstancesInput(instance *ec2.Instance) *ec2.StopInstancesInput {
	return &ec2.StopInstancesInput{
		InstanceIds: []*string{
			aws.String(*(instance.InstanceId)),
		},
	}
}

func (ei Ec2Instance) waitUntilInstanceStopped(input *ec2.DescribeInstancesInput) {
	ei.Ec2Api.WaitUntilInstanceStopped(input)
}

func (ei Ec2Instance) GetPublicIpAddress(instance *ec2.Instance) *string {
	input := &ec2.DescribeInstancesInput{
		InstanceIds: []*string{
			aws.String(*(instance.InstanceId)),
		},
	}
	resp, _ := ei.describeInstances(input)
	return resp.Reservations[0].Instances[0].PublicIpAddress
}

func (ei Ec2Instance) describeInstances(input *ec2.DescribeInstancesInput) (*ec2.DescribeInstancesOutput, error) {
	return ei.Ec2Api.DescribeInstances(input)
}

func (ei Ec2Instance) createDescribeInstancesInput(instance *ec2.Instance) *ec2.DescribeInstancesInput {
	return &ec2.DescribeInstancesInput{
		InstanceIds: []*string{aws.String(*(instance.InstanceId))},
	}
}
