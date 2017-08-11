package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/mux"
	"github.com/prometheus/client_golang/prometheus"
)

func worldHandler(histogram *prometheus.HistogramVec) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()

		defer r.Body.Close()

		defer func() { // Make sure we record a status.
			duration := time.Since(start)
			histogram.WithLabelValues(fmt.Sprintf("%d", 200)).Observe(duration.Seconds())
		}()

		if r.Method == "GET" {
			w.WriteHeader(200)
			w.Write([]byte(`{"mae":"asd"}`))
		}
	}
}

// var responseMetric = prometheus.NewHistogram(
// 	prometheus.HistogramOpts{
// 		Name:    "request_duration_milliseconds",
// 		Help:    "Request latency distribution",
// 		Buckets: prometheus.ExponentialBuckets(10.0, 1.13, 40),
// 	})

func prometheusHandler() http.Handler {
	return prometheus.Handler()
}

func main() {

	// prometheus.MustRegister(responseMetric)
	histogram := prometheus.NewHistogramVec(prometheus.HistogramOpts{
		Name: "hash_seconds",
		Help: "Time taken to create hashes",
	}, []string{"code"})

	r := mux.NewRouter()
	r.Handle("/metrics", prometheusHandler())

	r.Handle("/world", worldHandler(histogram))

	prometheus.Register(histogram)

	// Any other setup, then an http.ListenAndServe here
	log.Fatal(http.ListenAndServe(":8080", r))
}
