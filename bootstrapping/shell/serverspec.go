package shell

import (
	. "../role"
	"fmt"
	"os"
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

	os.Setenv("ROLE", s.Role.String())
	os.Setenv("USER", s.User)
	os.Setenv("PORT", s.Port)
	os.Setenv("KEY_PATH", s.Key)
	os.Setenv("HOST_IP", s.IpAddress)
	os.Setenv("SUDO_PASSWORD", s.SudoPassword)
	os.Setenv("SPEC_OPTS", "--color --format documentation")

	cmd := exec.Command("bundle", "exec", "rake", "spec")
	err := Shell{Command: *cmd}.executeCommand()
	fmt.Println("End Test with serverspec: " + s.Role)
	return err
}
