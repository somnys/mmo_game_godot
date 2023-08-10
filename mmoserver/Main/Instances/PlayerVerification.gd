extends Node


@onready var player_container_scene = preload("res://Main/Instances/PlayerContainer.tscn")

func start(player_id):
	#assumes verification always positive - to be changed later
	CreatePlayerContainer(player_id)
func CreatePlayerContainer(player_id):
	var new_player_container = player_container_scene.instance()
	new_player_container.name  = str(player_id)
	get_parent().add_child(new_player_container)
	
func FillPlayerContainer(player_container):
	pass
