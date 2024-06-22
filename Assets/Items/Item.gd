extends Sprite2D

@export var itemDict = {
	"itemID": "",
	"Amount": 0,
	"MagazineAmmo":0,
	"ReserveAmmo":0}

func _ready():
	add_to_group("Items")
	set_process_input(false)
	
	# Add data verification at some point
	var itemLoaderInfo = itemLoader.allItems[itemDict["itemID"]]
	
	if itemDict["MagazineAmmo"] > itemLoaderInfo["magSize"]:
		itemDict["MagazineAmmo"] = itemLoaderInfo["magSize"]
	
	if itemDict["ReserveAmmo"] > itemLoaderInfo["reserveCapacity"]:
		itemDict["ReserveAmmo"] = itemLoaderInfo["reserveCapacity"]
	
#removes item node
func remove_Item():
	queue_free()

#sets the display name and sprite texture with the current itemID
func update_Item():
	print(itemDict)
	texture = load(itemLoader.allItems[itemDict["itemID"]]["itemIconPath"])
	
	var displayName : String = itemLoader.allItems[itemDict["itemID"]]["itemName"]
	# Figure out how to read inputMap key
	#var pickupKey : String = OS.get_keycode_string()
	$ColorRect/PickupPopUp.text = "Press " + "E " + "to pickup " + displayName

func _on_item_area_body_entered(_body):
	set_process_input(true)
	$ColorRect.visible = true

func _on_item_area_body_exited(_body):
	set_process_input(false)
	$ColorRect.visible = false
