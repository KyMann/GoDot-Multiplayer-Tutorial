extends CanvasLayer

@onready var viewport1 = $GridContainer/Container1/SubViewport1
@onready var grid = $GridContainer

var viewports

func _ready():
	for playerId in GameManager.Players:
		var view : Viewport = get_node("GridContainer/Container" + str(playerId) + "/SubViewport" + str(playerId))
		if(view != null):
			var zoom_size = (grid.get_child_count() + 1)/2
			var cam : Camera2D = view.get_node("Camera2D")
			
			view.world_2d = viewport1.world_2d
			
			var remote_transform := RemoteTransform2D.new()
			remote_transform.remote_path = cam.get_path()
			GameManager.Players[playerId]["scene"].add_child(remote_transform)
