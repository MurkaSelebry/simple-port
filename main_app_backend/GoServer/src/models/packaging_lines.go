package models

import (
	"gorm.io/gorm"
)

type PackagingLine struct {
	gorm.Model
	OrderID          uint   `json:"order_id"`
	OpCode           string `json:"op_code"`
	ShipmentNumber   string `json:"shipment_number"`
	ShipmentDate     string `json:"shipment_date"`
	Line             string `json:"line"`
	Description      string `json:"description"`
	PackagingType    string `json:"packaging_type"`
	DefaultPackaging int    `json:"default_packaging"`
	PackagingNumbers string `json:"packaging_numbers"`
	PackagingLetters string `json:"packaging_letters"`
	Details          string `json:"details"`
}

func GetAllPackagingLines() ([]PackagingLine, error) {
	var PackagingLines []PackagingLine
	err := Database.Find(&PackagingLines).Error
	return PackagingLines, err
}

func GetPackagingLineByID(id int) (PackagingLine, error) {
	var PackagingLine PackagingLine
	err := Database.First(&PackagingLine, id).Error
	return PackagingLine, err
}

func CreatePackagingLine(PackagingLine PackagingLine) (PackagingLine, error) {
	err := Database.Create(&PackagingLine).Error
	return PackagingLine, err
}

func UpdatePackagingLine(id int, updatedData PackagingLine) (PackagingLine, error) {
	var PackagingLine PackagingLine
	err := Database.First(&PackagingLine, id).Error
	if err != nil {
		return PackagingLine, err
	}
	err = Database.Model(&PackagingLine).Updates(updatedData).Error
	return PackagingLine, err
}

func DeletePackagingLine(id int) error {
	err := Database.Delete(&PackagingLine{}, id).Error
	return err
}
