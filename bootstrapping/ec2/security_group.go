package ec2

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/ec2/ec2iface"
)

type SecurityGroup struct {
	Ec2Api ec2iface.EC2API
	Name   string
}

func (sg SecurityGroup) GetSecurityGroupId() string {
	params := sg.createSecurityGroupInput()
	resp, _ := sg.Ec2Api.DescribeSecurityGroups(params)
	return *(resp.SecurityGroups[0].GroupId)
}

func (sg SecurityGroup) createSecurityGroupInput() *ec2.DescribeSecurityGroupsInput {
	return &ec2.DescribeSecurityGroupsInput{
		Filters: []*ec2.Filter{
			{
				Name: aws.String("tag:Name"),
				Values: []*string{
					aws.String(sg.Name),
				},
			},
		},
	}
}
