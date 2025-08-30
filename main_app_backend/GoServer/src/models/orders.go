package models

import (
	"gorm.io/gorm"
)

type Order struct {
	gorm.Model
	OpCode         string `json:"op_code"`
	Description    string `json:"description"`
	Type           string `json:"type"`
	ShipmentNumber string `json:"shipment_number"`
	DeliveryDate   string `json:"delivery_date"`
}

func GetAllOrders() ([]Order, error) {
	var orders []Order
	err := Database.Find(&orders).Error
	return orders, err
}

func GetOrderByID(id int) (Order, error) {
	var order Order
	err := Database.First(&order, id).Error
	return order, err
}

func CreateOrder(order Order) (Order, error) {
	err := Database.Create(&order).Error
	return order, err
}

func UpdateOrder(id int, updatedData Order) (Order, error) {
	var order Order
	err := Database.First(&order, id).Error
	if err != nil {
		return order, err
	}
	err = Database.Model(&order).Updates(updatedData).Error
	return order, err
}

func DeleteOrder(id int) error {
	err := Database.Delete(&Order{}, id).Error
	return err
}
