package builder

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	svc "github.com/aws/aws-sdk-go/service/ec2"

	. "../role"
	. "../ssh"
)

const REGION = "ap-northeast-1"

type Builder struct {
	Role Role
	Ssh  Ssh
}

func (b Builder) Build(parentAmiId string) {
	// Builderの作成
	ec2Service := b.createEc2Service()
	amiBuilder := AmiBuilder{Ec2Service: ec2Service}
	ec2Builder := Ec2Builder{Ec2Service: ec2Service}
	provisioner := Provisioner{}

	// EC2インスタンスを起動
	instanceId, publicIpAddress, err := ec2Builder.Build(parentAmiId)
	if err != nil {
		fmt.Println(err.Error())
		return
	}

	provisionError := provisioner.Provision(b.Role, b.Ssh, publicIpAddress)
	if provisionError != nil {
		fmt.Println(provisionError.Error())
		ec2Builder.Destroy(instanceId)
		return
	}

	// AMIの作成
	amiBuilder.Build(
		instanceId,
		b.Role,
		parentAmiId,
	)

	// EC2インスタンスを削除
	ec2Builder.Destroy(instanceId)
}

func (b Builder) createEc2Service() *svc.EC2 {
	return svc.New(session.New(), &aws.Config{Region: aws.String(REGION)})
}
