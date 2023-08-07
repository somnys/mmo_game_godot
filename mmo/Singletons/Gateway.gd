extends Node

var network = ENetMultiplayerPeer.new()
var gateway_api = SceneMultiplayer.new()
var ip = "127.0.0.1"
var port = 13521

var username
var password



func _ready():
	pass


func _process(delta):
	#setup polling
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
	RequestLogin()

func RequestLogin():
	print("Connecting to gateway to request login")
	#call function LoginRequest in gateway server
	rpc_id(1, "LoginRequest", username, password)
	username = ""
	password = ""
	
@rpc("any_peer")
func ReturnLoginRequest(result):
	print("Result received")
	if result == true:
		print("Login Successful")
		get_node("/root/LoginScreen").attempt.text = "Login Successful"
		Server.ConnectToServer()
		network.close()
	else:
		print("Please provide correct username and password")
		get_node("/root/LoginScreen").login_button.disabled = false
		get_node("/root/LoginScreen").attempt.text = "Please provide correct username and password"
		multiplayer.disconnect("connection_failed", _OnConnectionFailed)
		multiplayer.disconnect("connected_to_server", _OnConnectionSucceded)
		network.close()

#dummy functions for rpc
@rpc("any_peer") func LoginRequest(username, password): pass
