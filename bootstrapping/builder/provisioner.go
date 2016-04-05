package builder

import (
	. "../role"
	"../shell"
	. "../ssh"
)

const EC2_USER = "ec2-user"

type Provisioner struct{}

func (p Provisioner) Provision(role Role, ssh Ssh, publicIpAddress string) error {
	recipe := "configuration/roles/" + role.String() + ".rb"

	// Itamaeでプロビジョニング
	shell.Itamae{
		Recipe:    recipe,
		User:      EC2_USER,
		Port:      ssh.ItamaePort,
		Key:       ssh.Key,
		IpAddress: publicIpAddress,
	}.Execute()

	// Serverspecでテスト
	err := shell.Serverspec{
		Role:         role,
		User:         EC2_USER,
		SudoPassword: "",
		Port:         ssh.ServerspecPort,
		Key:          ssh.Key,
		IpAddress:    publicIpAddress,
	}.Execute()

	return err
}
