package builder

import (
	ec2Client "github.com/aws/aws-sdk-go/service/ec2"

	"../shell"
)

const EC2_USER = "ec2-user"

type Provisioner struct {
	Ec2Api ec2Client.EC2
}

func (p Provisioner) Provision(config Config, publicIpAddress string) error {
	recipe := "configuration/roles/" + config.Role + ".rb"

	// Itamaeでプロビジョニング
	shell.Itamae{
		Recipe:    recipe,
		User:      EC2_USER,
		Port:      config.ItamaePort,
		Key:       config.Key,
		IpAddress: publicIpAddress,
	}.Execute()

	// Serverspecでテスト
	err := shell.Serverspec{
		Role:         config.Role,
		User:         EC2_USER,
		SudoPassword: "",
		Port:         config.ServerspecPort,
		Key:          config.Key,
		IpAddress:    publicIpAddress,
	}.Execute()

	return err
}
