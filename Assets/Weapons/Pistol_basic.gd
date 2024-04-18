extends "res://Assets/Item.gd"

func _ready():
	itemDict["Type"] = "WeaponLight"
	itemDict["ItemName"] = "PistolBasic"
	itemDict["Id"] = 1
	print(itemDict)
	set_process_input(false)
	
# when player chracter enters area, connect the PickupClick signal
# to the addtoInventory function and connect that signal to the
# Player invemtory dictionary and add the fucking item to it
func _on_area_2d_body_entered(body):
	set_process_input(true)
	$ColorRect.visible = true

func _on_area_2d_body_exited(body):
	set_process_input(false)
	$ColorRect.visible = false
	
func _input(event):
	if event.is_action_released("PickupItem"):
		addItem.emit()
		print("pickup works")
