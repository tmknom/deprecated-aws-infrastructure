package shell

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
)

type Shell struct {
	Command exec.Cmd
}

func (s Shell) executeCommand() (err error) {
	outReader, err := s.Command.StdoutPipe()
	if err != nil {
		return
	}

	errReader, err := s.Command.StderrPipe()
	if err != nil {
		return
	}

	var bufout, buferr bytes.Buffer
	outReader2 := io.TeeReader(outReader, &bufout)
	errReader2 := io.TeeReader(errReader, &buferr)

	s.Command.Start()
	outScanner := bufio.NewScanner(outReader2)
	for outScanner.Scan() {
		fmt.Println(outScanner.Text())
	}

	errScanner := bufio.NewScanner(errReader2)
	for errScanner.Scan() {
		fmt.Println("[stderr]" + errScanner.Text())
	}

	s.Command.Wait()
	return
}

func (s Shell) cdConfigurationPath() {
	os.Chdir("./configuration")
}

func (s Shell) cdProjectRoot() {
	os.Chdir(s.getProjectRoot())
}

func (s Shell) getProjectRoot() string {
	path, _ := filepath.Abs("../")
	return path
}
