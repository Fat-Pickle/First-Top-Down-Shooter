extends "res://Assets/Item.gd"

func _ready():
	itemDict["Type"] = "WeaponLight"
	itemDict["ItemName"] = "PistolBasic"
	itemDict["Id"] = 1

	set_process_input(false)
	
# These 2 functions make the pickup item pop up display
# and makes it so that it doesn't register the input constantly
func _on_area_2d_body_entered(body):
	set_process_input(true)
	$ColorRect.visible = true

func _on_area_2d_body_exited(body):
	set_process_input(false)
	$ColorRect.visible = false
	

