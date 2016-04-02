package shell

import (
	"fmt"
	"os"
	"path/filepath"
	"os/exec"
	"bufio"
)

type Shell struct {
	Command exec.Cmd
}

func (s Shell) executeCommand() {
	out, err := s.Command.StdoutPipe()

	if err != nil {
		fmt.Println(err)
		return
	}

	s.Command.Start()
	scanner := bufio.NewScanner(out)
	for scanner.Scan() {
		fmt.Println(scanner.Text())
	}

	s.Command.Wait()
}

func (s Shell) cdProjectRoot() {
	os.Chdir(s.getProjectRoot())
}

func (s Shell) getProjectRoot() string {
	path, _ := filepath.Abs("../")
	return path
}
