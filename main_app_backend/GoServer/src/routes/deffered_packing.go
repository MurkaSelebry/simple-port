package routes

import (
	"main/src/controllers"
	"main/src/middlewares"

	"github.com/go-chi/chi/v5"
)

func defferedPackingsGroupRouter(r chi.Router) {
	r.Route("/deferred_packaging", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			r.Use(middlewares.AuthMiddleware)
			r.Get("/", controllers.GetAllDefferedPackings)       // Получить все заказы
			r.Get("/{id}", controllers.GetDefferedPackingByID)   // Получить заказ по ID
			r.Post("/", controllers.CreateDefferedPacking)       // Создать новый заказ
			r.Put("/{id}", controllers.UpdateDefferedPacking)    // Обновить заказ
			r.Delete("/{id}", controllers.DeleteDefferedPacking) // Удалить заказ
		})
	})
}
