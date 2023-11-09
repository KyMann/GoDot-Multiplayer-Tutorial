extends Node2D

@export var PlayerScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name=str(GameManager.Players[i].id)
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		
		var view: Viewport = get_node(currentPlayer.name + "/LocalWindow")
		print(view.name)
		if view != null:
			var cam : Camera2D = view.get_node("Camera2D")
#			view.world_2d = get_node(".").world_2d
			cam.global_position = currentPlayer.global_position
		
		index += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
