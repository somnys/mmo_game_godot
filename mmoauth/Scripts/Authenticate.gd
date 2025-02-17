extends Node

#Client-to-gateway port 13521
#Gateway-to-Auth port 13517
#Client-to-gameserver port 13512
#Game server-to-Auth port 13524

var network = ENetMultiplayerPeer.new()
var port = 13517
var max_servers = 5
var token = ""


func _ready():
	StartServer()
	
func StartServer():
	network.create_server(port, max_servers)
	multiplayer.multiplayer_peer = network
	print("Authentication server started")
	
	network.connect("peer_connected", _Peer_Connected)
	network.connect("peer_disconnected", _Peer_Disconnected)
	
	
func _Peer_Connected(gateway_id): 
	print("Gateway " + str(gateway_id) + " connected")
	
	
func _Peer_Disconnected(gateway_id):
	print("Gateway " + str(gateway_id) + " disconnected")
	
	
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
		
		randomize()
		token = str(randi()).sha256_text() + str(int(Time.get_unix_time_from_system()))
		var gameserver = "GameServer1" #to będzie zmienione jak będzie więcej niż jeden serwer ; czyli nie bedzie do wyjebania
		GameServers.DistributeLoginToken(token, gameserver)
		
	print("Authentication result send to gateway server")
	rpc_id(gateway_id, "AuthenticationResults", result, player_id, token)
	
#dummy functions for rpc
@rpc("any_peer") func AuthenticationResults(result, player_id): pass
