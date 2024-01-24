extends CanvasLayer

@onready var viewport0 = $GridContainer/Container0/SubViewport0
@onready var grid = $GridContainer

var viewports

func _ready():
	#set active world in GameMangager
	GameManager.activeWorld = $GridContainer/Container0/SubViewport0/world1
	
	#setup Grid Container
	print("setting up grid")
	var gridSize = GameManager.Players.size()
	var gridContainer = get_node("GridContainer")
	match gridSize:
		#1 player - 1 view
		1:
			gridContainer.columns = 1
		#2 players - 2 side by side
		2:
			gridContainer.columns = 2
		#3 players - 1 on top, 2 on bottom
		#would need 2 grid contianers???
		#4 players - 2x2 grid
		4:
			gridContainer.columns = 2
			
	for playerId in GameManager.Players:
		
		
		var view : Viewport = get_node("GridContainer/Container" + str(playerId) + "/SubViewport" + str(playerId))
		if(view != null):
			var _zoom_size = (grid.get_child_count() + 1)/2
			var cam : Camera2D = view.get_node("Camera"+str(playerId))
			
			view.world_2d = viewport0.world_2d
			
			var remote_transform := RemoteTransform2D.new()
			remote_transform.remote_path = cam.get_path()
			var scene = GameManager.Players[playerId]["scene"]
			GameManager.Players[playerId]["scene"].add_child(remote_transform)



