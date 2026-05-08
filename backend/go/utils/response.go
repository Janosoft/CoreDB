package utils

import (
	"encoding/json"
	"net/http"

	"CoreDB/models"
)

func SendResponse(
	w http.ResponseWriter,
	statusCode int,
	success bool,
	errStr string,
	data interface{},
) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)

	json.NewEncoder(w).Encode(models.LoginResponse{
		Success: success,
		Error:   errStr,
		Data:    data,
	})
}
