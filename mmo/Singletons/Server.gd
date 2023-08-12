extends Node

var network = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 13512
var token

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
	
	
@rpc("any_peer") 
func FetchToken(): 
	rpc_id(1, "ReturnToken", token)

@rpc("any_peer")
func ReturnTokenVerificationResults(result):
	if result == true:
		print("Successful token verification")
	else:
		print("Token verification failed, please try again")
		get_node("root/LoginScreen.tscn").login_button.disabled = false

#dummy functions for rpc to fuck off
@rpc("any_peer") func ReturnToken(token): pass
