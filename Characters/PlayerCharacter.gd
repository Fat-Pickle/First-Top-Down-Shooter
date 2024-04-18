extends CharacterBody2D

var Speed = 600
var Acceleration = 9.0

var input: Vector2

signal MouseClick
signal PickupClick

var inventory = {"WeaponLight":[],}

func get_input():
	input.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y = Input.get_action_strength("Backwards") - Input.get_action_strength("Forward")
	
	return input.normalized()

#Places the camera between the mouse cursor and player character
func set_camera():
	#gets the shorter screen length and sets that as the screen limit,
	#so that the player character doesn't go off the screen 
	var screen_size = get_viewport_rect().size
	
	if screen_size!=null:
		var res_limit = min(screen_size.x,screen_size.y)
		var mouse_pos = get_local_mouse_position()
		
		#Should probably rewrite this to be simpler
		if abs(mouse_pos.x) > res_limit:
			if mouse_pos.x < 0:
				mouse_pos.x = -res_limit
			else:
				mouse_pos.x = res_limit
		elif abs(mouse_pos.y) > res_limit:
			if mouse_pos.y < 0:
				mouse_pos.y = -res_limit
			else:
				mouse_pos.y = res_limit
				
		$PlayerCamera.position = mouse_pos/1.9

func _on_player_pickup_area_area_entered(area):
	print()
	

func _process(delta):
	#var angle = atan((mouse_pos.y)/(mouse_pos.x))
	var playerInput = get_input()
	
	var controlType = "Relative"
	
	match controlType:
		"Independent":
			velocity = lerp(velocity, playerInput * Speed, delta * Acceleration)
		"Relative":
			velocity = lerp(velocity, transform.basis_xform(Vector2(-playerInput.y,playerInput.x)) * Speed, delta * Acceleration)
	
	set_camera()
	move_and_slide()

func _physics_process(_delta):
	if Input.is_action_pressed("PrimaryClick"):
		MouseClick.emit()
		print("clicking")
	
	if Input.is_action_just_released("PickupItem"):
		PickupClick.emit()
		print("Pickup")
	look_at(get_global_mouse_position())
