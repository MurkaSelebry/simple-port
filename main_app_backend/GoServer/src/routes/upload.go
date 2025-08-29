package routes

import (
	"main/src/controllers"
	"main/src/middlewares"

	"github.com/go-chi/chi/v5"
)

func uploadRouter(r chi.Router) {
	r.Route("/upload", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			r.Use(middlewares.AuthMiddleware)
			r.Post("/", controllers.UploadHandler) // Создать новый заказ
		})
	})
}
