package builder

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	ec2Client "github.com/aws/aws-sdk-go/service/ec2"
)

const REGION = "ap-northeast-1"

type Builder struct {
	Config Config
}

func (b Builder) Build(parentAmiId string) {
	// Builderの作成
	ec2Api := b.createEc2Api()
	amiBuilder := AmiBuilder{Ec2Api: *ec2Api}
	ec2Builder := Ec2Builder{Ec2Api: *ec2Api}
	provisioner := Provisioner{Ec2Api: *ec2Api}

	// EC2インスタンスを起動
	instanceId, publicIpAddress, err := ec2Builder.Build(parentAmiId)
	if err != nil {
		fmt.Println(err.Error())
		return
	}

	provisionError := provisioner.Provision(b.Config, publicIpAddress)
	if provisionError != nil {
		fmt.Println(provisionError.Error())
		ec2Builder.Destroy(instanceId)
		return
	}

	// AMIの作成
	amiBuilder.Build(
		instanceId,
		b.Config.Role,
		parentAmiId,
	)

	// EC2インスタンスを削除
	ec2Builder.Destroy(instanceId)
}

func (b Builder) createEc2Api() *ec2Client.EC2 {
	return ec2Client.New(session.New(), &aws.Config{Region: aws.String(REGION)})
}
