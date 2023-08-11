extends Node


var network = ENetMultiplayerPeer.new()
var port = 13517
var ip = "127.0.0.1"

func _ready():
	ConnectToServer()
	
func ConnectToServer():
	network.create_client(ip, port)
	multiplayer.multiplayer_peer = network
	print("Attempting connection with auth server")
	multiplayer.connect("connection_failed", _OnConnectionFailed)
	multiplayer.connect("connected_to_server", _OnConnectionSucceded)
	
func _OnConnectionFailed():
	print("Failed to connect with auth server")
	
func _OnConnectionSucceded():
	print("Succesfully connected with auth server")
	
func AuthenticatePlayerData(username, password, player_id):
	print("Send authentication request")
	rpc_id(1, "AuthenticatePlayer", username, password, player_id)
	
#function will also send peer account_id on succesful authentication	
@rpc("any_peer")
func AuthenticationResults(result, player_id, token): 
	print("Result received and replaying to player login request")
	Gateway.ReturnLoginReq(result, player_id, token)
	
#dummy functions for rpc
@rpc("any_peer") func AuthenticatePlayer(username, password, player_id): pass
