extends Control

@export var Address = "127.0.0.1" #temporary
@export var port = 8910
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#this is called on the server and clients when someone connects
func peer_connected(id):
	print("Player Connected " + str(id))

#this is called on the server and clients on disconnect
func peer_disconnected(id):
	print("Player Disconnected " + str(id))

#this is only fired from clients
func connected_to_server():
	print("connected to Server!")

#this is only fired from clients
func connection_failed():
	print("Couldn't connect")

@rpc("any_peer", "call_local") #any - everyone will call, #authority - only when the authority it goes out to everyone else #local - I will also call on my end #remote - only on remote #reliable uses tcp, slower, #unreliable udp faster risky #unr ordered - comes in ordered
func start_game():
	var scene = load("res://testScene.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_host_button_down():
	peer = ENetMultiplayerPeer.new() #don't elocate on startup
	
	var error = peer.create_server(port, 2) #max number of players
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) #can select different compressions
	multiplayer.set_multiplayer_peer(peer)
	#we created a object to host, now we are saying we want to use that host as our peer
	print("Waiting for Players")
	
	


func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) #compression has to be the same across the board
	multiplayer.set_multiplayer_peer(peer)

func _on_play_button_button_down():
	#remote procedure call, call a function on any or all peers
	#rpc needs to be a seperate function with the proper annotations
	start_game.rpc() #.rpc call across everyone, .rcp_id calls only on one peer
