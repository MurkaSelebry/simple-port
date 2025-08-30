package controllers

import (
	"encoding/json"
	"main/src/models"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
)

func GetAllPackagingLines(w http.ResponseWriter, r *http.Request) {
	PackagingLines, err := models.GetAllPackagingLines()
	if err != nil {
		http.Error(w, "Unable to fetch PackagingLines", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(PackagingLines)
}

func GetPackagingLineByID(w http.ResponseWriter, r *http.Request) {
	PackagingLineID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	PackagingLine, err := models.GetPackagingLineByID(PackagingLineID)
	if err != nil {
		http.Error(w, "PackagingLine not found", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(PackagingLine)
}

func CreatePackagingLine(w http.ResponseWriter, r *http.Request) {
	var PackagingLine models.PackagingLine
	if err := json.NewDecoder(r.Body).Decode(&PackagingLine); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}
	newPackagingLine, err := models.CreatePackagingLine(PackagingLine)
	if err != nil {
		http.Error(w, "Unable to create PackagingLine", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(newPackagingLine)
}

func UpdatePackagingLine(w http.ResponseWriter, r *http.Request) {
	PackagingLineID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	var PackagingLine models.PackagingLine
	if err := json.NewDecoder(r.Body).Decode(&PackagingLine); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}
	updatedPackagingLine, err := models.UpdatePackagingLine(PackagingLineID, PackagingLine)
	if err != nil {
		http.Error(w, "Unable to update PackagingLine", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(updatedPackagingLine)
}

func DeletePackagingLine(w http.ResponseWriter, r *http.Request) {
	PackagingLineID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	err := models.DeletePackagingLine(PackagingLineID)
	if err != nil {
		http.Error(w, "Unable to delete PackagingLine", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}
