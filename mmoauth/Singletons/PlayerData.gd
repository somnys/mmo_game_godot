extends Node

var player_data

func _ready():
	var file = FileAccess.open("res://Data/PlayerData.json", FileAccess.READ)
	var json_object = JSON.new()
	var parse_err = json_object.parse(file.get_as_text())
	player_data = json_object.get_data()
