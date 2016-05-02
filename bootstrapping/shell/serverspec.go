package shell

import (
	. "../role"
	"fmt"
	"os/exec"
)

type Serverspec struct {
	Role         Role
	User         string
	SudoPassword string
	Port         string
	Key          string
	IpAddress    string
}

func (s Serverspec) Execute() error {
	fmt.Println("Test with serverspec: " + s.Role)
	Shell{}.cdConfigurationPath()
	cmd := exec.Command("fab", "spec_"+s.Role.String(), "-H", s.IpAddress)
	err := Shell{Command: *cmd}.executeCommand()
	fmt.Println("End Test with serverspec: " + s.Role)
	return err
}
