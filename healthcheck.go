package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	resp, err := http.Get(fmt.Sprintf("http://127.0.0.1:%s/health", getOr("PORT", "8080")))
	if err != nil || (resp != nil && resp.StatusCode >= 400) {
		os.Exit(1)
	}
}

func getOr(name string, defaultValue string) string {
	var ret = os.Getenv(name)
	if len(ret) == 0 {
		ret = defaultValue
	}
	return ret
}
