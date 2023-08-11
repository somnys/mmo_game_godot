extends Node

var network = ENetMultiplayerPeer.new()
var gateway_api = SceneMultiplayer.new()
var port = 1912
var ip = "127.0.0.1"

@onready var gameserver = get_node("/root/Server")


func _ready():
	StartServer()
	
	
func _process(delta):
	if get_tree().get_multiplayer() == null:
		return
	if not multiplayer.has_network_peers():
		return
	multiplayer.poll()
	

func StartServer():
	network.create_client(ip, port)
	get_tree().set_multiplayer(gateway_api, self.get_path())
	multiplayer.set_multiplayer_peer(network)
	
	multiplayer.connect("connection_failed", _OnConnectionFailed)
	multiplayer.connect("connected_to_server", _OnConnectionSucceded)
	

func _OnConnectionFailed():
	print("Failed to connect with auth server")
	
	
func _OnConnectionSucceded():
	print("Succesfully connected with auth server") 
	

@rpc("any_peer")
func RecieveLoginToken(token):
	gameserver.expected_tokens.append(token)
