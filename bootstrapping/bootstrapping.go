package main

import (
	"fmt"
	"os"

	. "./builder"
	. "./role"
	. "./ssh"
)

const BASE_IMAGE_ID = "ami-f80e0596"

func main() {
	parentAmiId := BASE_IMAGE_ID

	switch Role(os.Args[1]) {
	case BASE:
		Builder{
			Role: BASE,
			Ssh: Ssh{
				Key:            os.Getenv("SSH_INITIALIZE_KEY_PATH"),
				ItamaePort:     "22",
				ServerspecPort: os.Getenv("SSH_PORT"),
			},
		}.Build(parentAmiId)
	case RAILS:
		Builder{
			Role: RAILS,
			Ssh: Ssh{
				Key:            os.Getenv("SSH_INITIALIZE_KEY_PATH"),
				ItamaePort:     os.Getenv("SSH_PORT"),
				ServerspecPort: os.Getenv("SSH_PORT"),
			},
		}.Build(parentAmiId)
	default:
		fmt.Println("invalid argument, please input [ base, rails ]")
	}
}
