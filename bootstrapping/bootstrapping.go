package main

import (
	"os"

	. "./builder"
)

const BASE_IMAGE_ID = "ami-f80e0596"

func main() {
	parentAmiId := BASE_IMAGE_ID

	Builder{
		Config: Config{
			Role:           "base",
			Key:            os.Getenv("SSH_INITIALIZE_KEY_PATH"),
			ItamaePort:     "22",
			ServerspecPort: os.Getenv("SSH_PORT"),
		},
	}.Build(parentAmiId)
}
