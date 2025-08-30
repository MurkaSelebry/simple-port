package controllers

import (
	"encoding/json"
	"log"
	"main/src/models"
	"net/http"
	"strconv"
	"time"
)

// Login authenticates a user and returns a JWT token
// @Summary User login
// @Description Authenticate user with email and password
// @Tags Auth
// @Accept json
// @Produce json
// @Param user body models.UserSec true "User credentials"
// @Success 200 {object} map[string]interface{} "success"
// @Failure 400 {object} map[string]interface{} "error"
// @Router /auth/login [post]
func Login(w http.ResponseWriter, r *http.Request) {
	var input models.UserSec
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	loggedUser, err := input.Login()
	if err != nil {
		log.Printf("Error during login: %v", err)
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	cookie := &http.Cookie{
		Name:     "jwt",
		Value:    loggedUser.Token,
		Expires:  time.Now().Add(30 * 24 * time.Hour), // Expires in 24 hours
		HttpOnly: true,
		Secure:   true,
	}
	http.SetCookie(w, cookie)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status":  "success",
		"message": "User logged in successfully",
		"data":    loggedUser,
	})
}

// Register creates a new user account
// @Summary User registration
// @Description Register a new user with email, password and nickname
// @Tags Auth
// @Accept json
// @Produce json
// @Param user body models.UserSec true "User registration data"
// @Success 201 {object} map[string]interface{} "success"
// @Failure 400 {object} map[string]interface{} "error"
// @Router /auth/register [post]
func Register(w http.ResponseWriter, r *http.Request) {
	var input models.UserSec
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	loggedUser, err := input.Register()
	if err != nil {
		log.Printf("Error during registration: %v", err)
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status":  "success",
		"message": "User registered successfully",
		"data":    loggedUser,
	})
}

// GetProfile returns the current user's profile
// @Summary Get user profile
// @Description Get current authenticated user's profile information
// @Tags Auth
// @Produce json
// @Security Bearer
// @Success 200 {object} map[string]interface{} "success"
// @Failure 400 {object} map[string]interface{} "error"
// @Failure 401 {object} map[string]interface{} "unauthorized"
// @Router /auth/profile [get]
func GetProfile(w http.ResponseWriter, r *http.Request) {
	// Retrieve userId from context
	userId, ok := r.Context().Value("userId").(string)
	if !ok || userId == "" {
		http.Error(w, "User ID is required", http.StatusBadRequest)
		return
	}

	// Convert userId to uint
	userIDUint, err := strconv.ParseUint(userId, 10, 32)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	startup, err := models.FetchUser(uint(userIDUint))
	if err != nil {
		log.Printf("Error fetching user: %v", err)
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status":  "success",
		"message": "User fetched successfully",
		"data":    startup,
	})
}
