extends Node2D

@export var PlayerScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for playerId in GameManager.Players:
		var currentPlayerScene = PlayerScene.instantiate()
		currentPlayerScene.name=str(playerId)
		add_child(currentPlayerScene)

		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(playerId):
				currentPlayerScene.global_position = spawn.global_position
		
		##TODO: generate viewports according to players instead of pulling from a starting list
		var view: Viewport = get_node("GridContainer/Container" + str(playerId) + "/SubViewport" + str(playerId))

		if view != null:
			var cam : Camera2D = view.get_node("Camera2D")
#			view.world_2d = get_node(".").world_2d
			cam.global_position = currentPlayerScene.global_position
		
		GameManager.Players[playerId]["scene"] = currentPlayerScene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
