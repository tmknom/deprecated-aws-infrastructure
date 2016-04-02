package ec2

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
)

type SecurityGroup struct {
	Ec2Api ec2.EC2
	Name   string
}

func (sg SecurityGroup) GetSecurityGroupId() string {
	input := sg.createSecurityGroupInput()
	resp := sg.describeSecurityGroups(input)
	return *(resp.SecurityGroups[0].GroupId)
}

func (sg SecurityGroup) describeSecurityGroups(input *ec2.DescribeSecurityGroupsInput) *ec2.DescribeSecurityGroupsOutput {
	resp, _ := sg.Ec2Api.DescribeSecurityGroups(input)
	return resp
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
