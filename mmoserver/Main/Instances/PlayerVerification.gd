extends Node


@onready var player_container_scene = preload("res://Main/Instances/PlayerContainer.tscn")

func start(player_id, account_id):
	#assumes verification always positive - to be changed later
	CreatePlayerContainer(player_id, account_id)
	
func CreatePlayerContainer(player_id, account_id):
	var new_player_container = player_container_scene.instance()
	new_player_container.name  = str(player_id)
	get_parent().add_child(new_player_container)
	new_player_container.account_id = account_id

func DelPlayerContainer(player_id):
	get_parent().get_node(str(player_id)).queue_free()
	
func FillPlayerContainer(player_container):
	#get account data from database via account_id given by auth upon succesful authorization
	player_container.account_info = ServerData.server_data[str(player_container.account_id)]
