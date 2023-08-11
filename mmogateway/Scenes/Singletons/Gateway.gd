extends Node

var network = ENetMultiplayerPeer.new()
var gateway_api = SceneMultiplayer.new()
var port = 13521
var max_players = 100


func _process(delta):
	if gateway_api.has_multiplayer_peer():
		gateway_api.poll()
		
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
	print("Login request received")
	var player_id = gateway_api.get_remote_sender_id()
	Authenticate.AuthenticatePlayerData(username, password, player_id)

func ReturnLoginReq(result, player_id, token):
	await rpc_id(player_id, "ReturnLoginRequest", result, token)
	#gateway_api.disconnect_peer(player_id)

#dummy functions for rpc
@rpc("any_peer") func ReturnLoginRequest(result): pass
