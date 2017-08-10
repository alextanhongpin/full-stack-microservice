package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
)

func main() {
	var port = flag.Int("port", 8080, "The server port")

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {

		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"hello": "again"}`)
	})
	fmt.Println("This is by println")
	fmt.Printf("This is by %s", "printf")

	log.Printf("Listening to port *:%d. Press ctrl + c to cancel.\n", *port)
	http.ListenAndServe(fmt.Sprintf(":%d", *port), nil)
}
