extends Node


var network = ENetMultiplayerPeer.new()
var port = 13517
var ip = "192.168.0.73"

func _ready():
	pass
	
func StartServer():
	network.create_client(ip, port)
	multiplayer.multiplayer_peer = network
	print("Authentication server started")
	
	network.connect("connection_failed", _OnConnectionFailed)
	network.connect("connected_to_server", _OnConnectionSucceded)
	
func _OnConnectionFailed():
	print("Failed to connect")
	
func _OnConnectionSucceded():
	print("Succesfully connected")
	
func AuthenticatePlayer(username, password, account_id, player_id):
	pass
	
@rpc("any_peer")
func AuthenticationResults(result, player_id): 
	pass
