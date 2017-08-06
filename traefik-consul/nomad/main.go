package main

import (
	"log"
	"net/http"
)

func main() {
	client := &http.Client{}

	n := 100

	req, err := http.NewRequest("GET", "http://localhost:80/instable", nil)
	if err != nil {
		log.Printf("Got error %#v\n", err)
		return
	}
	// req.Header.Add("Host", "web.consul.localhost")
	req.Host = "web.consul.localhost"
	log.Printf("req %#v\n", req)

	for i := 0; i < n; i++ {

		resp, err := client.Do(req)
		if err != nil {
			log.Printf("Got error %#v\n", err)
			return
		}

		log.Printf("Status: %s", resp.Status)

	}

}
