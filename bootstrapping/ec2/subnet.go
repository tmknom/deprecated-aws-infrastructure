package ec2

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/ec2/ec2iface"
)

type Subnet struct {
	Ec2Api ec2iface.EC2API
	Name   string
}

func (s Subnet) GetSubnetId() string {
	params := s.createSubnetInput()
	resp, _ := s.Ec2Api.DescribeSubnets(params)
	return *(resp.Subnets[0].SubnetId)
}

func (s Subnet) createSubnetInput() *ec2.DescribeSubnetsInput {
	return &ec2.DescribeSubnetsInput{
		Filters: []*ec2.Filter{
			{
				Name: aws.String("tag:Name"),
				Values: []*string{
					aws.String(s.Name),
				},
			},
		},
	}
}
