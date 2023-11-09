extends CharacterBody2D


const SPEED = 500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2

func _ready():
	direction = Vector2(1,0).rotated(rotation)

func _physics_process(delta):
	# Add the gravity.
	velocity = SPEED * direction
	if not is_on_floor():
		velocity.y += gravity * 1 * delta
	move_and_slide()


func _on_damage_body_entered(body):
#	print("bulletcollision")
#	print(body)
	#reduce player health
	if body.name in GameManager.Players: #or body.name == "Mob"
		#reduce entity health
		print("Hit!")
		self.queue_free()
	#on wall impact create crystal get_used_cells_id(idOfWalls)
	#on bullet - bullet collision create something cool
	
