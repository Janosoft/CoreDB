extends Node2D

@onready var email_input = $Panel/email
@onready var password_input = $Panel/password
@onready var dialog = $Dialog

var http

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_request_completed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_login_php_pressed() -> void:
	var email = email_input.text
	var password = password_input.text
	var data = {"email": email, "password": password}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]

	http.request("http://localhost/CoreDB/backend/php/login.php", headers, HTTPClient.METHOD_POST, json_data)
	
func _on_request_completed(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print (response)
	
	if response and response["success"]:
		dialog.dialog_text = "Login exitoso: %s - %s" % [response["data"]["email"], response["data"]["codigo"]]
		dialog.popup_centered()
	else:
		dialog.dialog_text = "Error en el login: %s" % [response["error"]]
		dialog.popup_centered()
