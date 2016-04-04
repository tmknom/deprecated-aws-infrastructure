package builder

import (
	ec2Client "github.com/aws/aws-sdk-go/service/ec2"

	"../shell"
)

const EC2_USER = "ec2-user"

type Provisioner struct {
	Ec2Api ec2Client.EC2
}

type ProvisioningConfig struct {
	Role           string
	Key            string
	ItamaePort     string
	ServerspecPort string
}

func (p Provisioner) Provision(provisioningConfig ProvisioningConfig, publicIpAddress string) error {
	recipe := "configuration/roles/" + provisioningConfig.Role + ".rb"

	// Itamaeでプロビジョニング
	shell.Itamae{
		Recipe:    recipe,
		User:      EC2_USER,
		Port:      provisioningConfig.ItamaePort,
		Key:       provisioningConfig.Key,
		IpAddress: publicIpAddress,
	}.Execute()

	// Serverspecでテスト
	err := shell.Serverspec{
		Role:         provisioningConfig.Role,
		User:         EC2_USER,
		SudoPassword: "",
		Port:         provisioningConfig.ServerspecPort,
		Key:          provisioningConfig.Key,
		IpAddress:    publicIpAddress,
	}.Execute()

	return err
}
