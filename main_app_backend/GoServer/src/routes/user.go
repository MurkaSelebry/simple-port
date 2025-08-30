package routes

import (
	"log"
	"main/src/controllers"
	"main/src/middlewares"
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
)

func startupsGroupRouter(r chi.Router) {
	r.Route("/auth", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			r.Use(middlewares.AuthMiddleware)
			r.Get("/profile", func(w http.ResponseWriter, r *http.Request) {
				log.Println("GET /auth/profile")
				controllers.GetProfile(w, r)
			})
		})
		// r.Get("/profile", controllers.GetProfile)

		r.Post("/login", func(w http.ResponseWriter, r *http.Request) {
			log.Println("POST /auth/login")
			controllers.Login(w, r)
		})
		r.Post("/register", func(w http.ResponseWriter, r *http.Request) {
			log.Println("POST /auth/register")
			controllers.Register(w, r)
		})
	})
}

func SetupRoutes() *chi.Mux {
	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	// CORS configuration
	corsMiddleware := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Origin", "Content-Type", "Accept", "Authorization"},
		ExposedHeaders:   []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           int(12 * time.Hour / time.Second),
	})
	r.Use(corsMiddleware.Handler)

	r.Route("/api", func(r chi.Router) {
		startupsGroupRouter(r)
		ordersGroupRouter(r)
		defferedPackingsGroupRouter(r)
		packagingLinesGroupRouter(r)
		packagingsGroupRouter(r)
		uploadRouter(r)
		userPortalsGroupRouter(r)
	})

	return r
}
