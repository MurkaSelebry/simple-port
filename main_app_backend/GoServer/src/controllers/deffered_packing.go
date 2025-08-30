package controllers

import (
	"encoding/json"
	"main/src/models"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
)

func GetAllDefferedPackings(w http.ResponseWriter, r *http.Request) {
	DefferedPackings, err := models.GetAllDefferedPackings()
	if err != nil {
		http.Error(w, "Unable to fetch DefferedPackings", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(DefferedPackings)
}

func GetDefferedPackingByID(w http.ResponseWriter, r *http.Request) {
	DefferedPackingID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	DefferedPacking, err := models.GetDefferedPackingByID(DefferedPackingID)
	if err != nil {
		http.Error(w, "DefferedPacking not found", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(DefferedPacking)
}

func CreateDefferedPacking(w http.ResponseWriter, r *http.Request) {
	var DefferedPacking models.DefferedPacking
	if err := json.NewDecoder(r.Body).Decode(&DefferedPacking); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}
	newDefferedPacking, err := models.CreateDefferedPacking(DefferedPacking)
	if err != nil {
		http.Error(w, "Unable to create DefferedPacking", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(newDefferedPacking)
}

func UpdateDefferedPacking(w http.ResponseWriter, r *http.Request) {
	DefferedPackingID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	var DefferedPacking models.DefferedPacking
	if err := json.NewDecoder(r.Body).Decode(&DefferedPacking); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}
	updatedDefferedPacking, err := models.UpdateDefferedPacking(DefferedPackingID, DefferedPacking)
	if err != nil {
		http.Error(w, "Unable to update DefferedPacking", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(updatedDefferedPacking)
}

func DeleteDefferedPacking(w http.ResponseWriter, r *http.Request) {
	DefferedPackingID, _ := strconv.Atoi(chi.URLParam(r, "id"))
	err := models.DeleteDefferedPacking(DefferedPackingID)
	if err != nil {
		http.Error(w, "Unable to delete DefferedPacking", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}
