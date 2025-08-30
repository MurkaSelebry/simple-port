package controllers

import (
	"encoding/json"
	"main/src/models"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
)

func GetAllUserPortals(w http.ResponseWriter, r *http.Request) {
	UserPortals, err := models.GetAllUserPortals()
	if err != nil {
		http.Error(w, "Unable to fetch UserPortals", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(UserPortals)
}

func GetUserPortalByID(w http.ResponseWriter, r *http.Request) {
	UserPortalID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	UserPortal, err := models.GetUserPortalByID(UserPortalID)
	if err != nil {
		http.Error(w, "UserPortal not found", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(UserPortal)
}

func CreateUserPortal(w http.ResponseWriter, r *http.Request) {
	var UserPortal models.UserPortal
	if err := json.NewDecoder(r.Body).Decode(&UserPortal); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}
	newUserPortal, err := models.CreateUserPortal(UserPortal)
	if err != nil {
		http.Error(w, "Unable to create UserPortal", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(newUserPortal)
}

func UpdateUserPortal(w http.ResponseWriter, r *http.Request) {
	UserPortalID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	var UserPortal models.UserPortal
	if err := json.NewDecoder(r.Body).Decode(&UserPortal); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}
	updatedUserPortal, err := models.UpdateUserPortal(UserPortalID, UserPortal)
	if err != nil {
		http.Error(w, "Unable to update UserPortal", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(updatedUserPortal)
}

func DeleteUserPortal(w http.ResponseWriter, r *http.Request) {
	UserPortalID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	err := models.DeleteUserPortal(UserPortalID)
	if err != nil {
		http.Error(w, "Unable to delete UserPortal", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}
