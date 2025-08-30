package controllers

import (
	"encoding/json"
	"main/src/models"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
)

func GetAllPackagings(w http.ResponseWriter, r *http.Request) {
	Packagings, err := models.GetAllPackagings()
	if err != nil {
		http.Error(w, "Unable to fetch Packagings", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(Packagings)
}

func GetPackagingByID(w http.ResponseWriter, r *http.Request) {
	PackagingID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	Packaging, err := models.GetPackagingByID(PackagingID)
	if err != nil {
		http.Error(w, "Packaging not found", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(Packaging)
}

func CreatePackaging(w http.ResponseWriter, r *http.Request) {
	var Packaging models.Packaging
	if err := json.NewDecoder(r.Body).Decode(&Packaging); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}
	newPackaging, err := models.CreatePackaging(Packaging)
	if err != nil {
		http.Error(w, "Unable to create Packaging", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(newPackaging)
}

func UpdatePackaging(w http.ResponseWriter, r *http.Request) {
	PackagingID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	var Packaging models.Packaging
	if err := json.NewDecoder(r.Body).Decode(&Packaging); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}
	updatedPackaging, err := models.UpdatePackaging(PackagingID, Packaging)
	if err != nil {
		http.Error(w, "Unable to update Packaging", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(updatedPackaging)
}

func DeletePackaging(w http.ResponseWriter, r *http.Request) {
	PackagingID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	err := models.DeletePackaging(PackagingID)
	if err != nil {
		http.Error(w, "Unable to delete Packaging", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}
