extends Node

var network = ENetMultiplayerPeer.new()
var port = 13517
var max_servers = 5

func _ready():
	pass
	
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
func AuthenticatePlayer(username, password, id, player_id): 
	pass
