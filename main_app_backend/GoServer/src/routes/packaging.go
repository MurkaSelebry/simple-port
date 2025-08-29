package routes

import (
	"main/src/controllers"
	"main/src/middlewares"

	"github.com/go-chi/chi/v5"
)

func packagingsGroupRouter(r chi.Router) {
	r.Route("/packaging", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			r.Use(middlewares.AuthMiddleware)
			r.Get("/", controllers.GetAllPackagings)       // Получить все заказы
			r.Get("/{id}", controllers.GetPackagingByID)   // Получить заказ по ID
			r.Post("/", controllers.CreatePackaging)       // Создать новый заказ
			r.Put("/{id}", controllers.UpdatePackaging)    // Обновить заказ
			r.Delete("/{id}", controllers.DeletePackaging) // Удалить заказ
		})
	})
}
