extends Node

@onready var main_interface = get_parent()
@onready var player_container_scene = preload("res://Main/Instances/PlayerContainer.tscn")

var awaiting_verification = {}

func start(player_id):
	awaiting_verification[player_id] = {"Timestamp": Time.get_unix_time_from_system()}
	main_interface.FetchToken(player_id)
	
	
	
func Verify(player_id, token):
	var token_verification = false
	while Time.get_unix_time_from_system() - int(token.right(64)) <=30:
		if main_interface.expected_tokens.has(token):
			token_verification = true
			CreatePlayerContainer(player_id, 1) #TUTAJ!!!!!!!!!!!
			awaiting_verification.erase(player_id)
			main_interface.expected_tokens.erase(token)
			break
		else:
			$YieldTimer.start()
			await $YieldTimer.timeout
	
	if token_verification == false:
		awaiting_verification.erase(player_id)
		
		
		
func _on_verification_expiration_timeout():
	var current_time = Time.get_unix_time_from_system()
	var start_time
	if awaiting_verification == {}:
		pass
	else:
		for key in awaiting_verification.keys():
			start_time = awaiting_verification[key].Timestamp
			if current_time - start_time >= 10:
				awaiting_verification.erase(key)
				var connected_peers = Array(get_tree().get_multiplayer().get_network_connected_peers()) #TUTAJ!!!
				if connected_peers.has(key):
					main_interface.ReturnTokenVerificationResults(key,false)
					main_interface.network.disconnect_peer(key)
	print("Awaiting verification:")
	print(awaiting_verification)
	
	
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



