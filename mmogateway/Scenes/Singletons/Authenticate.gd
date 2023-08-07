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
	
func AuthenticatePlayer(username, password, player_id):
	print("Send authentication request")
	rpc_id(1, "AuthenticatePlayer", username, password, player_id)
	
@rpc("any_peer")
func AuthenticationResults(result, player_id): 
	print("Result received and replaying to player login request")
	Gateway.ReturnLoginRequest(result, player_id)
