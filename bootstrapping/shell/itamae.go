package shell

import (
	"fmt"
	"os/exec"
)

type Itamae struct {
	Recipe    string
	User      string
	Port      string
	Key       string
	IpAddress string
}

func (i Itamae) Execute() {
	fmt.Println("Provisioning with itamae: " + i.Recipe)
	Shell{}.cdProjectRoot()
	cmd := exec.Command("itamae", "ssh", i.Recipe, "-u", i.User, "-p", i.Port, "-i", i.Key, "-h", i.IpAddress)
	Shell{Command: *cmd}.executeCommand()
}
