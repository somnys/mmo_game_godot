extends Node


var network = ENetMultiplayerPeer.new()
var gateway_api = SceneMultiplayer.new()
var port = 13524
var max_players = 100

var gameserverlist = {}


func _ready():
	StartServer()
	
	
func _process(delta):
	if gateway_api.has_multiplayer_peer():
		gateway_api.poll()
	

func StartServer():
	network.create_server(port, max_players)
	get_tree().set_multiplayer(gateway_api, self.get_path())
	multiplayer.set_multiplayer_peer(network)
	print("Hub server started")
	
	network.connect("peer_connected", _Peer_Connected)
	network.connect("peer_disconnected", _Peer_Disconnected)	
	
	
func _Peer_Connected(gameserver_id):
	print("Game Server " + str(gameserver_id) + " connected")
	#coś tam do dodania kiedyś
	gameserverlist["GameServer1"] = gameserver_id
	print(gameserverlist)
	
	
func _Peer_Disconnected(gameserver_id):
	print("Game Server " + str(gameserver_id) + " disconnected")
	
	
func DistributeLoginToken(token, gameserver):
	var gameserver_peer_id = gameserverlist[gameserver]
	rpc_id(gameserver_peer_id, "ReceiveLoginToken", token)
	
#dummy functions for rpc to fuck off
@rpc("any_peer") func ReceiveLoginToken(token) : pass
