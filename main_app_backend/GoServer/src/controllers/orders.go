package controllers

import (
	"encoding/json"
	"main/src/models"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
)

func GetAllOrders(w http.ResponseWriter, r *http.Request) {
	orders, err := models.GetAllOrders()
	if err != nil {
		http.Error(w, "Unable to fetch orders", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(orders)
}

func GetOrderByID(w http.ResponseWriter, r *http.Request) {
	orderID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	order, err := models.GetOrderByID(orderID)
	if err != nil {
		http.Error(w, "Order not found", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(order)
}

func CreateOrder(w http.ResponseWriter, r *http.Request) {
	var order models.Order
	if err := json.NewDecoder(r.Body).Decode(&order); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}
	newOrder, err := models.CreateOrder(order)
	if err != nil {
		http.Error(w, "Unable to create order", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(newOrder)
}

func UpdateOrder(w http.ResponseWriter, r *http.Request) {
	orderID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	var order models.Order
	if err := json.NewDecoder(r.Body).Decode(&order); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}
	updatedOrder, err := models.UpdateOrder(orderID, order)
	if err != nil {
		http.Error(w, "Unable to update order", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(updatedOrder)
}

func DeleteOrder(w http.ResponseWriter, r *http.Request) {
	orderID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	err := models.DeleteOrder(orderID)
	if err != nil {
		http.Error(w, "Unable to delete order", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}
