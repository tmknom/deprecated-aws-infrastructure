package main

import (
	"fmt"
	"os"

	. "./builder"
	. "./role"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Println("how to use : go run bootstrapping.go [base|rails]")
		return
	}

	role := NewRole(os.Args[1])
	Builder{Role: role}.Build()
}
