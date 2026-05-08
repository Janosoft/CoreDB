package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"CoreDB/db"
	"CoreDB/handlers"
	"CoreDB/middleware"
)

func main() {
	err := db.Init()
	if err != nil {
		log.Fatal(err)
	}

	http.HandleFunc("/login", middleware.CORS(middleware.Logger(handlers.LoginHandler)))

	server := &http.Server{
		Addr:         ":8080",
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 5 * time.Second,
	}

	fmt.Println("Servidor en :8080")

	log.Fatal(server.ListenAndServe())
}
