package models

type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type LoginResponse struct {
	Success bool   `json:"success"`
	Error   string `json:"error"`
	Data    any    `json:"data"`
}

type UserData struct {
	Codigo string `json:"codigo"`
	Email  string `json:"email"`
}
