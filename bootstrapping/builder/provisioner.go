package builder

import (
	. "../ec2"
	. "../role"
	"../shell"
)

type Provisioner struct{}

func (p Provisioner) Provision(role Role, publicIpAddress PublicIpAddress) error {
	// Itamaeでプロビジョニング
	shell.Itamae{
		Role:      role,
		IpAddress: publicIpAddress.String(),
	}.Execute()

	// Serverspecでテスト
	err := shell.Serverspec{
		Role:      role,
		IpAddress: publicIpAddress.String(),
	}.Execute()

	return err
}
