extends Control

@onready var username_input = $VBoxContainer/Username
@onready var password_input = $VBoxContainer/Password
@onready var login_button = $VBoxContainer/LoginButton
@onready var invalid_data_popup = $InvalidData
@onready var attempt = $VBoxContainer/AttemptMessage


func _on_login_button_pressed():
	if username_input.text == "" or password_input.text == "":
		invalid_data_popup.visible = true
	else:
		login_button.disabled = true
		var username = username_input.get_text()
		var password = password_input.get_text()
		attempt.visible = true
		print("Attempting to login...")
		Gateway.ConnectToServer(username, password)


func _on_accept_button_pressed():
	invalid_data_popup.visible = false
