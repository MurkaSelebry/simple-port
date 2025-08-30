package routes

import (
	"main/src/controllers"
	"main/src/middlewares"

	"github.com/go-chi/chi/v5"
)

func ordersGroupRouter(r chi.Router) {
	r.Route("/orders", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			r.Use(middlewares.AuthMiddleware)
			r.Get("/", controllers.GetAllOrders)       // Получить все заказы
			r.Get("/{id}", controllers.GetOrderByID)   // Получить заказ по ID
			r.Post("/", controllers.CreateOrder)       // Создать новый заказ
			r.Put("/{id}", controllers.UpdateOrder)    // Обновить заказ
			r.Delete("/{id}", controllers.DeleteOrder) // Удалить заказ
		})
	})
}
