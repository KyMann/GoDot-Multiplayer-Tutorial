extends Node2D

@export var PlayerScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():

	for playerId in GameManager.Players:
		#create view Containers
		createChildPort(playerId)
		
		#create players
		print("creating player" + str(playerId))
		var currentPlayerScene = PlayerScene.instantiate()
		currentPlayerScene.name=str(playerId)
		currentPlayerScene.controls=load("res://p"+str(playerId)+"_controls.tres") ##"res://p0_controls.tres"
		add_child(currentPlayerScene)

		#spawn in players
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(playerId):
				currentPlayerScene.global_position = spawn.global_position
		
		#create camera for player
		#remember our starting scope is in /root/Splitscreen_component/GridContainer/Container0/SubViewport0/world1
		var view: Viewport = get_node("/root/Splitscreen_component/GridContainer/Container" + str(playerId) + "/SubViewport" + str(playerId))

		if view != null:
			var cam : Camera2D = view.get_node("Camera"+str(playerId))
#			view.world_2d = get_node(".").world_2d
			cam.global_position = currentPlayerScene.global_position
		
		GameManager.Players[playerId]["scene"] = currentPlayerScene
		
		
func createChildPort(playerID):
	if playerID != 0:
		print("creating viewport"+str(playerID))
		var container = Container.new()
		container.name= "Container"+str(playerID)
		
		var subViewport = SubViewport.new()
		subViewport.name = "SubViewport"+str(playerID)
		
		var newCamera = Camera2D.new()
		newCamera.name = "Camera"+str(playerID)
		
		subViewport.add_child(newCamera)
		container.add_child(subViewport)
		get_node("/root/Splitscreen_component/GridContainer").add_child(container)
