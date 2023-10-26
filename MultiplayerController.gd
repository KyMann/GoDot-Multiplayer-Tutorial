extends Control

@export var port = 8910
var Address
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	await fetch_ip()
	await get_tree().create_timer(.5).timeout
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		host_game()
	get_tree().get_first_node_in_group("IPLabel").text = "My IP: " + Address

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#this is called on the server and clients when someone connects
func peer_connected(id):
	print("Player Connected " + str(id))

#this is called on the server and clients on disconnect
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for playerID in players:
		if playerID.name== str(id):
			playerID.queue_free()

#this is only fired from clients
func connected_to_server():
	print("connected to Server!")
	SendPlayerInformation.rpc_id(1, $Name.text, multiplayer.get_unique_id())
#this is only fired from clients
func connection_failed():
	print("Couldn't connect")

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id]= {
			"name": name,
			"id":id,
			"score":0
		}
	if multiplayer.is_server():
		for playerID in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[playerID].name, playerID)

@rpc("any_peer", "call_local") #any - everyone will call, #authority - only when the authority it goes out to everyone else #local - I will also call on my end #remote - only on remote #reliable uses tcp, slower, #unreliable udp faster risky #unr ordered - comes in ordered
func start_game():
	var scene = load("res://testScene.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_host_button_down():
	host_game()
	SendPlayerInformation($Name.text, multiplayer.get_unique_id())
	
func host_game():
	print("IP:", Address)
	peer = ENetMultiplayerPeer.new() #don't elocate on startup
	
	var error = peer.create_server(port, 2) #max number of players
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) #can select different compressions
	multiplayer.set_multiplayer_peer(peer)
	#we created a object to host, now we are saying we want to use that host as our peer
	print("Waiting for Players")
	
func fetch_ip():
	var http = HTTPRequest.new()
	add_child(http)
	var ip = await http.request_completed.connect(return_ip)
	await http.request("https://api.ipify.org")

func return_ip(result, response_code, headers, body):
	var ip = body.get_string_from_utf8()
	print("return", ip)
	Address = ip

func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	Address = $IP.text
	print("IP", Address)
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) #compression has to be the same across the board
	multiplayer.set_multiplayer_peer(peer)

func _on_play_button_button_down():
	#remote procedure call, call a function on any or all peers
	#rpc needs to be a seperate function with the proper annotations
	start_game.rpc() #.rpc call across everyone, .rcp_id calls only on one peer
