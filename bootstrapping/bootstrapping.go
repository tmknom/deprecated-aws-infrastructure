package main

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	ec2Client "github.com/aws/aws-sdk-go/service/ec2"

	"./ec2"
)

const SUBNET_NAME = "Testing-Tokyo-Public-Subnet-1"
const SSH_SECURITY_GROUP_NAME = "Testing-SSH-SecurityGroup"
const INITIALIZE_SECURITY_GROUP_NAME = "Testing-Initialize-SecurityGroup"

const INITIALIZE_KEY_NAME = "initialize"
const BASE_IMAGE_ID = "ami-f80e0596"

func main() {
	ec2Api := createEc2Api()

	// EC2インスタンスを起動
	instance, err := createInstance(BASE_IMAGE_ID, *ec2Api)
	if err != nil {
		fmt.Println(err.Error())
		return
	}
	fmt.Println(instance)
	fmt.Println("end createInstance")
}

func createInstance(imageId string, ec2Api ec2Client.EC2) (interface{}, error) {
	param := ec2.Ec2InstanceParam{
		ImageId:                   imageId,
		KeyName:                   INITIALIZE_KEY_NAME,
		SubnetId:                  ec2.Subnet{Ec2Api: ec2Api, Name: SUBNET_NAME}.GetSubnetId(),
		SshSecurityGroupId:        ec2.SecurityGroup{Ec2Api: ec2Api, Name: SSH_SECURITY_GROUP_NAME}.GetSecurityGroupId(),
		InitializeSecurityGroupId: ec2.SecurityGroup{Ec2Api: ec2Api, Name: INITIALIZE_SECURITY_GROUP_NAME}.GetSecurityGroupId(),
	}
	ec2Instance := ec2.Ec2Instance{Ec2Api: ec2Api}
	return ec2Instance.Create(param)
}

func createEc2Api() *ec2Client.EC2 {
	return ec2Client.New(session.New(), &aws.Config{Region: aws.String("ap-northeast-1")})
}
