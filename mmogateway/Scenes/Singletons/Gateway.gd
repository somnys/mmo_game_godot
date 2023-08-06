extends Node

var network = ENetMultiplayerPeer.new()
var gateway_api = SceneMultiplayer.new()
var port = 13521
var max_players = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	StartServer()

func StartServer():
	network.create_server(port, max_players)
	get_tree().set_multiplayer(gateway_api, self.get_path())
	multiplayer.set_multiplayer_peer(network)
	print("Gateway server started")
	
	network.connect("peer_connected", _Peer_Connected)
	network.connect("peer_disconnected", _Peer_Disconnected)	

func _Peer_Connected(player_id): 
	print("User " + str(player_id) + " connected")
	
func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " disconnected")
	
@rpc("any_peer")
func LoginRequest(username, password):
	pass
	
func ReturnLoginRequest(result, player_id):
	pass
