package main

import (
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	ec2Client "github.com/aws/aws-sdk-go/service/ec2"

	"./builder"
)

const BASE_IMAGE_ID = "ami-f80e0596"
const REGION = "ap-northeast-1"

func main() {
	parentAmiId := BASE_IMAGE_ID
	provisioningConfig := builder.ProvisioningConfig{
		Role:           "base",
		Key:            os.Getenv("SSH_INITIALIZE_KEY_PATH"),
		ItamaePort:     "22",
		ServerspecPort: os.Getenv("SSH_PORT"),
	}

	// Builderの作成
	ec2Api := createEc2Api()
	amiBuilder := builder.AmiBuilder{Ec2Api: *ec2Api}
	ec2Builder := builder.Ec2Builder{Ec2Api: *ec2Api}
	provisioner := builder.Provisioner{Ec2Api: *ec2Api}

	// EC2インスタンスを起動
	instanceId, publicIpAddress, err := ec2Builder.Build(parentAmiId)
	if err != nil {
		fmt.Println(err.Error())
		return
	}

	provisionError := provisioner.Provision(provisioningConfig, publicIpAddress)
	if provisionError != nil {
		fmt.Println(provisionError.Error())
		//ec2Builder.Destroy(instanceId)
		//return
	}

	// AMIの作成
	amiBuilder.Build(
		instanceId,
		provisioningConfig.Role,
		parentAmiId,
	)

	// EC2インスタンスを削除
	ec2Builder.Destroy(instanceId)
}

func createEc2Api() *ec2Client.EC2 {
	return ec2Client.New(session.New(), &aws.Config{Region: aws.String(REGION)})
}
