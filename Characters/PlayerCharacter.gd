extends CharacterBody2D

var Speed = 600
var Acceleration = 9.0

var input: Vector2

@export var controlType = "Relative"

var playerInventory = {"WeaponLight":{},"WeaponMedium":{},"WeaponHeavy":{},"Grenade":{}}
# Currently equipped weapon from playerInventory
# Contains magazine and reserve information, as well as the itemID
var equipped = { }

#Contains array of all items in the play pickup area
var enteredItemsArea = []

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

# Manages movement of the player character 
func _process(delta):
	var playerInput = get_input()
	
	# Changes movement direction based on selected control mode
	match controlType:
		"Independent":
			velocity = lerp(velocity, playerInput * Speed, delta * Acceleration)
		"Relative":
			velocity = lerp(velocity, transform.basis_xform(Vector2(-playerInput.y,playerInput.x)) * Speed, delta * Acceleration)
	
	set_camera()
	move_and_slide()

# Consider replacing this with unhandled input method
func _physics_process(_delta):
	# Having this in physics process makes it behave smoother,
	# but also caps out the weapon fire rate
	if Input.is_action_pressed("PrimaryClick"):
		#print("clicking")
		var weapon = get_node_or_null("Weapon")
		
		if weapon != null and equipped != { } :
			weapon.fire_weapon()
	
	if Input.is_action_just_released("ReloadWeapon") and playerInventory != { } :
		$Weapon.reload_weapon()
	
	if Input.is_action_just_released("PickupItem"):
		print("Pickup")
		
		if enteredItemsArea!=[]:
			print(enteredItemsArea)
			
			# checks what type of node the entered area is, so that I can use the pickup
			# button for more than just picking up items
			if str(enteredItemsArea[0].get_parent()).contains("Item"):
				var Item = enteredItemsArea[0].get_parent()
				add_to_inventory(Item)
				print(playerInventory)
				
	look_at(get_global_mouse_position())

func add_to_inventory(Item):
	# Get the weapon's slot type
	var itemType = itemLoader.allItems[Item.itemDict["itemID"]]["itemType"]
	print("test",playerInventory[itemType])
	
	# adds item to inventory, and then removes it if the inventory slot is free
	if playerInventory[itemType] == {}:
		playerInventory[itemType] = Item.itemDict
		enteredItemsArea.erase(enteredItemsArea[0])
		Item.remove_Item()
		
		equipped = playerInventory[itemType]
		$CanvasLayer/Player_HUD.updateIcons()
	else:
		# If there is something already in the inventory, swap the item information
		# with eachother
		var originalItem = playerInventory[itemType]
		playerInventory[itemType] = Item.itemDict
		Item.itemDict = originalItem
		Item.update_Item()
		equipped = playerInventory[itemType]
		$CanvasLayer/Player_HUD.updateIcons()

func _on_player_pickup_area_area_entered(area):
	enteredItemsArea+=[area]
	#print(enteredItemsArea)

func _on_player_pickup_area_area_exited(area):
	enteredItemsArea.erase(area)


