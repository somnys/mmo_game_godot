extends Node
var server_data

func _ready():
	var file = FileAccess.open("res://Data/ServerData.json", FileAccess.READ)
	var json_object = JSON.new()
	var parse_err = json_object.parse(file.get_as_text())
	server_data = json_object.get_data()
