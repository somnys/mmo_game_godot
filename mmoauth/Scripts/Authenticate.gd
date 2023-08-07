extends Node

var network = ENetMultiplayerPeer.new()
var port = 13517
var max_servers = 5

func _ready():
	StartServer()
	
func StartServer():
	network.create_server(port, max_servers)
	multiplayer.multiplayer_peer = network
	print("Authentication server started")
	
	network.connect("peer_connected", _Peer_Connected)
	network.connect("peer_disconnected", _Peer_Disconnected)
	
func _Peer_Connected(gateway_id): 
	print("User " + str(gateway_id) + " connected")
func _Peer_Disconnected(gateway_id):
	print("User " + str(gateway_id) + " disconnected")
	
@rpc("any_peer")
func AuthenticatePlayer(username, password, player_id): 
	print("Authentication request received")
	var gateway_id = multiplayer.get_remote_sender_id()
	var result
	if not PlayerData.player_data.has(username):
		print("User not recognized")
		result = false
	elif not PlayerData.player_data[username]["Password"] == password:
		print("Incorrect password")
		result = false
	else:
		print("Successful authentication")
		result = true
	print("Authentication result send to gateway server")
	rpc_id(gateway_id, "AuthenticationResults", result, player_id)
	
	
