package main

import (
	"fmt"
	"os"

	"init-nextjs/internal/project"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Usage: create-next-project <project-name>")
		os.Exit(1)
	}

	if err := project.Setup(os.Args[1]); err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}
}
