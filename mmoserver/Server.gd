extends Node

var network = ENetMultiplayerPeer.new()
const port = 13512
var max_players = 20


func _ready():
	StartServer()
	
func StartServer():
	network.create_server(port, max_players)
	multiplayer.multiplayer_peer = network
	print("Server Started")
	
	network.connect("peer_connected", _Peer_Connected)
	network.connect("peer_disconnected", _Peer_Disconnected)
	
func _Peer_Connected(player_id): 
	print("User " + str(player_id) + " connected")
func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " disconnected")
