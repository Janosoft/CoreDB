package handlers

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"CoreDB/db"
	"CoreDB/models"
	"CoreDB/utils"

	"golang.org/x/crypto/bcrypt"
)

func LoginHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	if r.Method != http.MethodPost {
		utils.SendResponse(w, http.StatusMethodNotAllowed, false, "Método no permitido.", nil)
		return
	}

	var req models.LoginRequest
	err := json.NewDecoder(r.Body).Decode(&req)

	if err != nil {
		utils.SendResponse(w, http.StatusBadRequest, false, "JSON inválido.", nil)
		return
	}

	var codigo, email, hash string
	err = db.DB.QueryRow("SELECT codigo, email, password FROM usuarios WHERE email = ?", req.Email).Scan(&codigo, &email, &hash)

	if err != nil {
		if err == sql.ErrNoRows {
			utils.SendResponse(w, http.StatusUnauthorized, false, "Usuario no encontrado.", nil)
			return
		}

		utils.SendResponse(w, http.StatusInternalServerError, false, "Error interno.", nil)
		return
	}

	err = bcrypt.CompareHashAndPassword([]byte(hash), []byte(req.Password))

	if err != nil {
		utils.SendResponse(w, http.StatusUnauthorized, false, "Contraseña incorrecta.", nil)
		return
	}

	utils.SendResponse(w, http.StatusOK, true, "", models.UserData{Codigo: codigo, Email: email})
}
