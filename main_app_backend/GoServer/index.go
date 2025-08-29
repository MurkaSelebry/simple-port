package main

import (
	"log"
	"main/src/models"
	"main/src/routes"
	"main/src/utils"
	"net/http"
)

func main() {
	// Load environment variables
	utils.LoadEnv()

	// Open database connection
	models.OpenDatabaseConnection()

	// Auto migrate models
	models.AutoMigrateModels()

	// Set up routes
	router := routes.SetupRoutes()

	// Start the server
	log.Println("Starting server on :3000")
	if err := http.ListenAndServe(":3000", router); err != nil {
		log.Fatalf("Could not start server: %s\n", err)
	}
}
