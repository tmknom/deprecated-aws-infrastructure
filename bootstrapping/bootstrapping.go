package main

import (
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	ec2Client "github.com/aws/aws-sdk-go/service/ec2"

	"./builder"
	"./ec2"
	"./shell"
)

const SUBNET_NAME = "Testing-Tokyo-Public-Subnet-1"
const SSH_SECURITY_GROUP_NAME = "Testing-SSH-SecurityGroup"
const INITIALIZE_SECURITY_GROUP_NAME = "Testing-Initialize-SecurityGroup"

const INITIALIZE_KEY_NAME = "initialize"
const BASE_IMAGE_ID = "ami-f80e0596"
const REGION = "ap-northeast-1"

func main() {
	role := "base"
	parentAmiId := BASE_IMAGE_ID

	ec2Api := createEc2Api()

	// EC2インスタンスを起動
	param := createEc2InstanceParam(parentAmiId, *ec2Api)
	ec2Instance := ec2.Ec2Instance{Ec2Api: *ec2Api}
	instanceId, publicIpAddress, err := ec2Instance.Create(param)

	if err != nil {
		fmt.Println(err.Error())
		return
	}

	// Itamaeでプロビジョニング
	shell.Itamae{
		Recipe:    "configuration/roles/base.rb",
		User:      "ec2-user",
		Port:      "22",
		Key:       os.Getenv("SSH_INITIALIZE_KEY_PATH"),
		IpAddress: publicIpAddress,
	}.Execute()

	// Serverspecでテスト
	specError := shell.Serverspec{
		Role:         role,
		User:         os.Getenv("SSH_USER_NAME"),
		SudoPassword: os.Getenv("SUDO_PASSWORD"),
		Port:         os.Getenv("SSH_PORT"),
		Key:          os.Getenv("SSH_KEY_PATH"),
		IpAddress:    publicIpAddress,
	}.Execute()

	if specError != nil {
		fmt.Println(specError.Error())
		return
	}

	// EC2インスタンスを停止
	ec2Instance.Stop(instanceId)

	// AMIの作成
	builder.AmiBuilder{Ec2Api: *ec2Api}.Build(
		instanceId,
		role,
		parentAmiId,
	)

	// EC2インスタンスを削除
	ec2Instance.Terminate(instanceId)
}

func createEc2InstanceParam(imageId string, ec2Api ec2Client.EC2) ec2.Ec2InstanceParam {
	return ec2.Ec2InstanceParam{
		ImageId:                   imageId,
		KeyName:                   INITIALIZE_KEY_NAME,
		SubnetId:                  ec2.Subnet{Ec2Api: ec2Api, Name: SUBNET_NAME}.GetSubnetId(),
		SshSecurityGroupId:        ec2.SecurityGroup{Ec2Api: ec2Api, Name: SSH_SECURITY_GROUP_NAME}.GetSecurityGroupId(),
		InitializeSecurityGroupId: ec2.SecurityGroup{Ec2Api: ec2Api, Name: INITIALIZE_SECURITY_GROUP_NAME}.GetSecurityGroupId(),
	}
}

func createEc2Api() *ec2Client.EC2 {
	return ec2Client.New(session.New(), &aws.Config{Region: aws.String(REGION)})
}
