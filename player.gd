extends CharacterBody2D

@export var bullet :PackedScene
@export var controls: Resource = null
var follow_cam : Camera2D


#TODO: set up custom variables to handle sync to save you bandwidth
func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	follow_cam = get_node("LocalWindow/Camera2D")


func _physics_process(_delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority()== multiplayer.get_unique_id():
		if Input.is_action_just_pressed(self.controls.fire):
			fire.rpc()
	
	$GunRotation.rotation = gun_angle(self.controls.type, self.controls.player_index-1)
	if Input.is_action_just_pressed(self.controls.fire):
		fire()
		
	get_input()

	move_and_slide()

func get_input():
	velocity = Vector2(0,0)
	var speed = 200
	if Input.is_action_pressed(controls.move_right):
		velocity.x += speed
	if Input.is_action_pressed(controls.move_left):
		velocity.x -= speed
	if Input.is_action_pressed(controls.move_up):
		velocity.y -= speed
	if Input.is_action_pressed(controls.move_down):
		velocity.y += speed
	#TODO: renormalize speed

func gun_angle(type, device_int):
	var gun_rotation
	#if mouse, use mouse to player angel
	if type == 'mouse':
		var player_pos = self.global_position
		var mouse_pos = get_global_mouse_position()
		gun_rotation = player_pos.angle_to_point(mouse_pos)
		
	#if controller use right stick angle
	elif type == 'controller':
		var rs_look = Vector2()
		rs_look.y = Input.get_joy_axis(device_int, JOY_AXIS_RIGHT_Y)
		rs_look.x = Input.get_joy_axis(device_int, JOY_AXIS_RIGHT_X)
		gun_rotation = rs_look.angle()
		print(rs_look.y)
		#TODO is this always a radian?
	return gun_rotation
	

@rpc("any_peer", "call_local")
func fire():
	var b = bullet.instantiate()
	b.global_position = $GunRotation/BulletSpawn.global_position
	b.rotation_degrees = $GunRotation.rotation_degrees
	GameManager.activeWorld.add_child(b)

func hurt(damage):
	self.health -= damage
	if self.health <= 0:
		self.death()
		
func death():
	self.queue_free()
