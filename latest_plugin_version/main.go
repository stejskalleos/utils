package main

import (
	"fmt"
	"latestPluginVersion/rubygems"
	"latestPluginVersion/yumforeman"
	"os"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Usage: go run main.go foreman_plugin")
		return
	}

	plugin := os.Args[1]

	rubygems.CheckRubyGems(plugin)
	yumforeman.CheckYumForeman(plugin)
}
