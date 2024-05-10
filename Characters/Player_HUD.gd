extends Control

var playerHealth: int = 100
var maxPlayerHealth: int = 100

func _input(event):
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateIcons():
	# get_parent is called twicen since in the main scene the player HUD is a child
	# of a Canvas Layer, which is a child of the player Character
	var currentPlayerInventory = get_parent().get_parent().playerInventory
	
	pass

#changes the UI border outline to show which slot is currently selected
func _on_light_pressed():
	pass # Replace with function body.


func _on_medium_pressed():
	pass # Replace with function body.


func _on_heavy_pressed():
	pass # Replace with function body.
