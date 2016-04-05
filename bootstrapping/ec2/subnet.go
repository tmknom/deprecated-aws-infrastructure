package ec2

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
)

type Subnet struct {
	Ec2Api ec2.EC2
}

func (s Subnet) GetSubnetId(name string) string {
	input := s.createSubnetInput(name)
	resp := s.describeSubnets(input)
	return *(resp.Subnets[0].SubnetId)
}

func (s Subnet) describeSubnets(input *ec2.DescribeSubnetsInput) *ec2.DescribeSubnetsOutput {
	resp, _ := s.Ec2Api.DescribeSubnets(input)
	return resp
}

func (s Subnet) createSubnetInput(name string) *ec2.DescribeSubnetsInput {
	return &ec2.DescribeSubnetsInput{
		Filters: []*ec2.Filter{
			{
				Name: aws.String("tag:Name"),
				Values: []*string{
					aws.String(name),
				},
			},
		},
	}
}
