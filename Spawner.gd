extends Marker2D

signal itemSpawned

@export var spawnerItemDict = {
	"Type":"",
	"ItemName":"",
	"ItemID": "",
	"Amount": 0}

func _ready():
	spawn_item()
	# Instancizes the Item, reads the parameters from the Label
	# and sets them to the item
	
func spawn_item():
	# Instancizes the Item, reads the parameters from itemDict
	# and sets them to the item
	var item = preload("res://Assets/Items/Item.tscn").instantiate()
	item.itemDict = spawnerItemDict
	add_sibling.call_deferred(item)
	itemSpawned.emit()
