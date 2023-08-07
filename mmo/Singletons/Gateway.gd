extends Node

var network = ENetMultiplayerPeer.new()
var gateway_api = SceneMultiplayer.new()
var ip = "127.0.0.1"
var port = 13521

var username
var password


func _ready():
	pass # Replace with function body.


func _process(delta):
	if gateway_api.has_multiplayer_peer():
		gateway_api.poll()

func ConnectToServer(_username, _password):
	username = _username
	password = _password
	network.create_client(ip, port)
	get_tree().set_multiplayer(gateway_api, self.get_path())
	multiplayer.set_multiplayer_peer(network)
	
	multiplayer.connect("connection_failed", _OnConnectionFailed)
	multiplayer.connect("connected_to_server", _OnConnectionSucceded)

func _OnConnectionFailed():
	print("Failed to connect with gateway")
	
func _OnConnectionSucceded():
	print("Connected with gateway")
	LoginRequest(username, password)

func LoginRequest(_username, _password):
	print("Connecting to gateway to request login")
	rpc_id(1, "LoginRequest", _username, _password)
	username = ""
	password = ""
	
@rpc("any_peer")
func ReturnLoginRequest(results):
	print("Result received")
	if results == true:
		print("Login Successful")
		Server.ConnectToServer()
	else:
		print("Please provide correct username and password")
		get_node("/root/LoginScreen").login_button.disabled = false
		multiplayer.disconnect("connection_failed", _OnConnectionFailed)
		multiplayer.disconnect("connected_to_server", _OnConnectionSucceded)
	

