extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var syncPos = Vector2(0,0)
#var syncRot = 0
@export var bullet :PackedScene

#TODO: set up custom variables to handle sync to save you bandwidth
func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority()== multiplayer.get_unique_id():
		$GunRotation.look_at(get_viewport().get_mouse_position())# Add the gravity.
		if Input.is_action_just_pressed("Fire"):
					fire.rpc()
#		
		# Handle Jump.
#		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#			velocity.y = JUMP_VELOCITY
		#if not is_on_floor():
			#velocity.y += gravity * delta

		get_input.rpc()

		move_and_slide()
		#syncPos = global_position
#		syncRot = rotation_degrees
#	else:
#		global_position = global_position.lerp(syncPos, .05)
#		rotation_degrees = lerpf(rotation_degrees, syncRot, .05)

func get_input():
	velocity = Vector2(0,0)
	var speed = 200
	if Input.is_action_pressed('right'):
		velocity.x += speed
		print("right")
	if Input.is_action_pressed('left'):
		velocity.x -= speed
		print("left")
	if Input.is_action_pressed('up'):
		velocity.y -= speed
	if Input.is_action_pressed('down'):
		velocity.y += speed

@rpc("any_peer", "call_local")
func fire():
	var b = bullet.instantiate()
	b.global_position = $GunRotation/BulletSpawn.global_position
	b.rotation_degrees = $GunRotation.rotation_degrees
	get_tree().root.add_child(b)
