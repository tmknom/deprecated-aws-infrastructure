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

const BASE_IMAGE_ID = "ami-f80e0596"
const REGION = "ap-northeast-1"

func main() {
	role := "base"
	parentAmiId := BASE_IMAGE_ID

	// Builderの作成
	ec2Api := createEc2Api()
	ec2Builder := builder.Ec2Builder{Ec2Api: *ec2Api}
	amiBuilder := builder.AmiBuilder{Ec2Api: *ec2Api}

	// EC2インスタンスを起動
	instanceId, publicIpAddress, err := ec2Builder.Build(parentAmiId)
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
	ec2.Ec2Instance{Ec2Api: *ec2Api}.Stop(instanceId)

	// AMIの作成
	amiBuilder.Build(
		instanceId,
		role,
		parentAmiId,
	)

	// EC2インスタンスを削除
	ec2Builder.Destroy(instanceId)
}

func createEc2Api() *ec2Client.EC2 {
	return ec2Client.New(session.New(), &aws.Config{Region: aws.String(REGION)})
}
