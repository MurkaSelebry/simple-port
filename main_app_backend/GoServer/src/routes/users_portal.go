package routes

import (
	"main/src/controllers"
	"main/src/middlewares"

	"github.com/go-chi/chi/v5"
)

func userPortalsGroupRouter(r chi.Router) {
	r.Route("/users", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			r.Use(middlewares.AuthMiddleware)
			r.Get("/", controllers.GetAllUserPortals)       // Получить все заказы
			r.Get("/{id}", controllers.GetUserPortalByID)   // Получить заказ по ID
			r.Post("/", controllers.CreateUserPortal)       // Создать новый заказ
			r.Put("/{id}", controllers.UpdateUserPortal)    // Обновить заказ
			r.Delete("/{id}", controllers.DeleteUserPortal) // Удалить заказ
		})
	})
}
