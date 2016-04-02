package ami

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
)

type Ami struct {
	Ec2Api ec2.EC2
}

type AmiParam struct {
	InstanceId string
	Name       string
}

func (ami Ami) Create(amiParam AmiParam) {
	fmt.Println("Creating the AMI: " + amiParam.InstanceId)

	input := ami.createImageInput(amiParam)
	ami.createImage(input)
}

func (ami Ami) createImage(input *ec2.CreateImageInput) (*ec2.CreateImageOutput, error) {
	return ami.Ec2Api.CreateImage(input)
}

func (ami Ami) createImageInput(param AmiParam) *ec2.CreateImageInput {
	return &ec2.CreateImageInput{
		InstanceId: aws.String(param.InstanceId),
		Name:       aws.String(param.Name),
	}
}
