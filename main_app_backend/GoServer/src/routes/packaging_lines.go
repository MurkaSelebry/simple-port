package routes

import (
	"main/src/controllers"
	"main/src/middlewares"

	"github.com/go-chi/chi/v5"
)

func packagingLinesGroupRouter(r chi.Router) {
	r.Route("/packaging_lines", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			r.Use(middlewares.AuthMiddleware)
			r.Get("/", controllers.GetAllPackagingLines)       // Получить все заказы
			r.Get("/{id}", controllers.GetPackagingLineByID)   // Получить заказ по ID
			r.Post("/", controllers.CreatePackagingLine)       // Создать новый заказ
			r.Put("/{id}", controllers.UpdatePackagingLine)    // Обновить заказ
			r.Delete("/{id}", controllers.DeletePackagingLine) // Удалить заказ
		})
	})
}
