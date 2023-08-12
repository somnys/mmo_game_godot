extends Node

var network = ENetMultiplayerPeer.new()
var gateway_api = SceneMultiplayer.new()
var port = 1912
var ip = "127.0.0.1"

@onready var main_interface = get_node("/root/Server")


func _ready():
	StartClient()
	
	
func _process(delta):
	if get_tree().get_multiplayer() == null:
		return
	if gateway_api.has_multiplayer_peer():
		multiplayer.poll()
	
	

func StartClient():
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
func ReceiveLoginToken(token):
	main_interface.expected_tokens.append(token)
