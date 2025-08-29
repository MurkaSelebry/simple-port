package models

import (
	"errors"
	"log"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type UserSec struct {
	gorm.Model
	Nickname string `json:"nickname"`
	Email    string `json:"email" gorm:"unique"`
	Password string `json:"password"`
}

type AuthResponse struct {
	User  *UserSec `json:"user"`
	Token string   `json:"token"`
}

// Fetches a user from the database
func FetchUser(id uint) (*UserSec, error) {
	var user UserSec
	err := Database.Where("id = ?", id).First(&user).Error
	if err != nil {
		log.Printf("Error fetching user: %v", err)
		return &UserSec{}, err
	}
	return &user, nil
}

func FetchUserByEmail(email string) UserSec {
	var userFromDb UserSec
	Database.Where("email = ?", email).First(&userFromDb)

	return userFromDb
}

func (user *UserSec) HashPassword() error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), 14)

	user.Password = string(hashedPassword)
	return err
}

func CheckPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

func (user *UserSec) Register() (*AuthResponse, error) {
	var err error
	userFromDb := FetchUserByEmail(user.Email)

	if userFromDb.Email != "" {
		err = errors.New("email already taken")
		log.Println(err)
		return &AuthResponse{}, err
	}

	err = user.HashPassword()
	if err != nil {
		log.Printf("Error hashing password: %v", err)
		return &AuthResponse{}, err
	}

	err = Database.Model(&user).Create(user).Error
	if err != nil {
		log.Printf("Error creating user: %v", err)
		return &AuthResponse{}, err
	}

	token, err := GenerateJWT(user.ID)
	if err != nil {
		log.Printf("Error generating JWT: %v", err)
		return &AuthResponse{}, err
	}

	response := AuthResponse{
		User:  user,
		Token: token,
	}

	return &response, nil
}

func (user *UserSec) Login() (*AuthResponse, error) {
	var err error
	userFromDb := FetchUserByEmail(user.Email)

	if userFromDb.Email == "" {
		err = errors.New("User or password incorrect")
		log.Println(err)
		return &AuthResponse{}, err
	}

	var isCheckedPassword = CheckPasswordHash(user.Password, userFromDb.Password)
	if !isCheckedPassword {
		err = errors.New("User or password incorrect")
		log.Println(err)
		return &AuthResponse{}, err
	}
	token, err := GenerateJWT(userFromDb.ID)
	if err != nil {
		log.Printf("Error generating JWT: %v", err)
		return &AuthResponse{}, err
	}

	response := AuthResponse{
		User:  &userFromDb,
		Token: token,
	}

	return &response, nil
}

func (user *UserSec) UpdateUser(id string) (*UserSec, error) {
	if user.Password != "" {
		err := user.HashPassword()
		if err != nil {
			log.Printf("Error hashing password: %v", err)
			return &UserSec{}, err
		}
	}

	err := Database.Model(&UserSec{}).Where("id = ?", id).Updates(user).Error
	if err != nil {
		log.Printf("Error updating user: %v", err)
		return &UserSec{}, err
	}
	return user, nil
}
