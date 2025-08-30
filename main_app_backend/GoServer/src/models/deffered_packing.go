package models

import (
	"gorm.io/gorm"
)

type DefferedPacking struct {
	gorm.Model
	OpCode         string `json:"op_code"`
	Description    string `json:"description"`
	Type           string `json:"type"`
	ShipmentNumber string `json:"shipment_number"`
	DeliveryDate   string `json:"delivery_date"`
}

// TableName overrides the table name used by User to `profiles`
func (DefferedPacking) TableName() string {
	return "deferred_packaging"
}
func GetAllDefferedPackings() ([]DefferedPacking, error) {
	var DefferedPackings []DefferedPacking
	err := Database.Find(&DefferedPackings).Error
	return DefferedPackings, err
}

func GetDefferedPackingByID(id int) (DefferedPacking, error) {
	var DefferedPacking DefferedPacking
	err := Database.First(&DefferedPacking, id).Error
	return DefferedPacking, err
}

func CreateDefferedPacking(DefferedPacking DefferedPacking) (DefferedPacking, error) {
	err := Database.Create(&DefferedPacking).Error
	return DefferedPacking, err
}

func UpdateDefferedPacking(id int, updatedData DefferedPacking) (DefferedPacking, error) {
	var DefferedPacking DefferedPacking
	err := Database.First(&DefferedPacking, id).Error
	if err != nil {
		return DefferedPacking, err
	}
	err = Database.Model(&DefferedPacking).Updates(updatedData).Error
	return DefferedPacking, err
}

func DeleteDefferedPacking(id int) error {
	err := Database.Delete(&DefferedPacking{}, id).Error
	return err
}
