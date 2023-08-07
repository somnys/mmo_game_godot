extends Node

var network = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 13512

func _ready():
	pass
	#ConnectToServer()
	
func ConnectToServer():
	network.create_client(ip, port)
	multiplayer.multiplayer_peer = network
	print("Trying to connect")
	multiplayer.connect("connection_failed", _OnConnectionFailed)
	multiplayer.connect("connected_to_server", _OnConnectionSucceded)
	multiplayer.connect("server_disconnected", _OnServerTerminated)
	
func _OnConnectionFailed():
	print("Failed to connect")
	
func _OnConnectionSucceded():
	print("Succesfully connected")
	
func _OnServerTerminated():
	print("Server closed")
