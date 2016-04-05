package builder

import (
	. "../ec2"
	. "../role"
	"../shell"
	. "../ssh"
)

const EC2_USER = "ec2-user"

type Provisioner struct{}

func (p Provisioner) Provision(role Role, ssh Ssh, publicIpAddress PublicIpAddress) error {
	// Itamaeでプロビジョニング
	shell.Itamae{
		Recipe:    getRecipe(role),
		User:      EC2_USER,
		Port:      ssh.ItamaePort,
		Key:       ssh.Key,
		IpAddress: publicIpAddress.String(),
	}.Execute()

	// Serverspecでテスト
	err := shell.Serverspec{
		Role:         role,
		User:         EC2_USER,
		SudoPassword: "",
		Port:         ssh.ServerspecPort,
		Key:          ssh.Key,
		IpAddress:    publicIpAddress.String(),
	}.Execute()

	return err
}

func getRecipe(role Role) string {
	return "configuration/roles/" + role.String() + ".rb"
}
