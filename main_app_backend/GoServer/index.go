package main

import (
	"log"
	"main/src/models"
	"main/src/routes"
	"main/src/utils"
	"net/http"

	_ "main/docs" // This line is necessary for Swagger to find your docs
	httpSwagger "github.com/swaggo/http-swagger"
)

// @title Corporate Portal API
// @version 1.0
// @description Corporate Portal API for employee management
// @termsOfService http://swagger.io/terms/

// @contact.name API Support
// @contact.url http://portal.ru/support
// @contact.email support@portal.ru

// @license.name Apache 2.0
// @license.url http://www.apache.org/licenses/LICENSE-2.0.html

// @host localhost
// @BasePath /api
// @securityDefinitions.apikey Bearer
// @in header
// @name Authorization

func main() {
	// Load environment variables
	utils.LoadEnv()

	// Open database connection
	models.OpenDatabaseConnection()

	// Auto migrate models
	models.AutoMigrateModels()

	// Set up routes
	router := routes.SetupRoutes()

	// Add Swagger endpoint
	router.Get("/swagger/*", httpSwagger.Handler(
		httpSwagger.URL("/swagger/doc.json"),
	))

	// Start the server
	log.Println("Starting server on :3000")
	log.Println("Swagger UI available at: http://localhost:3000/swagger/")
	if err := http.ListenAndServe(":3000", router); err != nil {
		log.Fatalf("Could not start server: %s\n", err)
	}
}
