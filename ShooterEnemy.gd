extends CharacterBody2D

@export var bullet :PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
@rpc("any_peer", "call_local")

func fire():
	var b = bullet.instantiate()
	b.global_position = $GunRotation/BulletSpawn.global_position
	b.rotation_degrees = $GunRotation.rotation_degrees
	get_tree().root.add_child(b)

func hurt(damage):
	self.health -= damage
	print(self.health)
	if self.health <= 0:
		self.death()
		
func death():
	self.queue_free()
