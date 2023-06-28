package rubygems

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
)

type Gem struct {
	Name         string
	Version      string
	Dependencies Dependencies
}

type Dependencies struct {
	Runtime []RuntimeDep
}

type RuntimeDep struct {
	Name         string
	Requirements string
}

func CheckRubyGems(plugin string) {
	urlRubyGems := fmt.Sprintf("https://rubygems.org/api/v1/gems/%s.json", plugin)

	resp, err := http.Get(urlRubyGems)
	if err != nil {
		fmt.Println("Error sending request to RubyGems.org:", err)
		return
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}

	var gemDetails Gem
	err = json.Unmarshal(body, &gemDetails)

	if err != nil {
		fmt.Println("Error parsing JSON body:", err)
		return
	}

	fmt.Println("RubyGems:")
	fmt.Println(gemDetails.Name, gemDetails.Version)
	fmt.Println("Dependencies:")

	for _, value := range gemDetails.Dependencies.Runtime {
		var dep RuntimeDep = value
		fmt.Println("-> " + dep.Name + " " + dep.Requirements)
	}
}
