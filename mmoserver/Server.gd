extends Node

var network = ENetMultiplayerPeer.new()
const port = 13512
var max_players = 20

var expected_tokens = []

@onready var player_verification_process = get_node("PlayerVerification")


func _ready():
	StartServer()
	
	
func StartServer():
	network.create_server(port, max_players)
	multiplayer.multiplayer_peer = network
	print("Server Started")
	
	network.connect("peer_connected", _Peer_Connected)
	network.connect("peer_disconnected", _Peer_Disconnected)
	
func _Peer_Connected(player_id): 
	print("User " + str(player_id) + " connected")
	player_verification_process.Start(player_id)
	
	
func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " disconnected")
	

func _on_token_expiration_timeout():
	var current_time = Time.get_unix_time_from_system()
	var token_time
	if expected_tokens == []:
		pass
	else:
		for i in range(expected_tokens.size() -1, -1, -1):
			token_time = int(expected_tokens[i].right(64))
			if current_time - token_time >= 30:
				expected_tokens.remove(i)
	print("Expected Tokens:")
	print(expected_tokens)
	

func FetchToken(player_id):
	rpc_id(player_id, "FetchToken")
	
	
@rpc("any_peer")
func ReturnToken(token):
	var player_id = get_tree().get_rpc_sender_id()
	player_verification_process.Verify(player_id, token)
	

func ReturnTokenVerificationResults(player_id, result):
	rpc_id(player_id, "ReturnTokenVerificationResults", result)
	


