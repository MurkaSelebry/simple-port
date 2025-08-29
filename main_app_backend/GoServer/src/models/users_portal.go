package models

import (
	"gorm.io/gorm"
)

type UserPortal struct {
	gorm.Model
	Nickname string `json:"nickname"`
	Email    string `json:"email" gorm:"unique"`
	IsAdmin  bool   `json:"isAdmin"`
	FullName string `json:"fullName"`
}

func (UserPortal) TableName() string {
	return "users_portal"
}
func GetAllUserPortals() ([]UserPortal, error) {
	var UserPortals []UserPortal
	err := Database.Find(&UserPortals).Error
	return UserPortals, err
}

func GetUserPortalByID(id int) (UserPortal, error) {
	var UserPortal UserPortal
	err := Database.First(&UserPortal, id).Error
	return UserPortal, err
}

func CreateUserPortal(UserPortal UserPortal) (UserPortal, error) {
	err := Database.Create(&UserPortal).Error
	return UserPortal, err
}

func UpdateUserPortal(id int, updatedData UserPortal) (UserPortal, error) {
	var UserPortal UserPortal
	err := Database.First(&UserPortal, id).Error
	if err != nil {
		return UserPortal, err
	}
	err = Database.Model(&UserPortal).Updates(updatedData).Error
	return UserPortal, err
}

func DeleteUserPortal(id int) error {
	err := Database.Delete(&UserPortal{}, id).Error
	return err
}
