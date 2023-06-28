package yumforeman

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/PuerkitoBio/goquery"
)

func CheckYumForeman(plugin string) {
	url := "https://yum.theforeman.org/plugins/nightly/el8/x86_64"

	fmt.Println("\nForeman nightly:")

	reponse, err := http.Get(url)
	if err != nil {
		fmt.Println("Error sending request to yum.theforeman.org:", err)
		return
	}
	defer reponse.Body.Close()

	doc, err := goquery.NewDocumentFromReader(reponse.Body)
	if err != nil {
		fmt.Println(err)
	}

	doc.Find("table tr td a").Each(func(i int, s *goquery.Selection) {
		if strings.Contains(s.Text(), plugin) {
			fmt.Println("-> " + s.Text())
		}
	})
}
