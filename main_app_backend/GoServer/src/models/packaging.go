package models

import (
	"gorm.io/gorm"
)

type Packaging struct {
	gorm.Model
	Status              string `json:"status"`
	OpCode              string `json:"op_code"`
	ShipmentNumber      string `json:"shipment_number"`
	ShipmentDate        string `json:"shipment_date"`
	City                string `json:"city"`
	PlannedDeliveryDate string `json:"planned_delivery_date"`
}

func (Packaging) TableName() string {
	return "packaging"
}
func GetAllPackagings() ([]Packaging, error) {
	var Packagings []Packaging
	err := Database.Find(&Packagings).Error
	return Packagings, err
}

func GetPackagingByID(id int) (Packaging, error) {
	var Packaging Packaging
	err := Database.First(&Packaging, id).Error
	return Packaging, err
}

func CreatePackaging(Packaging Packaging) (Packaging, error) {
	err := Database.Create(&Packaging).Error
	return Packaging, err
}

func UpdatePackaging(id int, updatedData Packaging) (Packaging, error) {
	var Packaging Packaging
	err := Database.First(&Packaging, id).Error
	if err != nil {
		return Packaging, err
	}
	err = Database.Model(&Packaging).Updates(updatedData).Error
	return Packaging, err
}

func DeletePackaging(id int) error {
	err := Database.Delete(&Packaging{}, id).Error
	return err
}
