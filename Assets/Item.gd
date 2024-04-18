extends Sprite2D

var itemDict = {
	"Type":"",
	"ItemName":"",
	"Id": 0,
	"Amount": 0}

signal addItem(itemDict)

func remove_Item():
	queue_free()
	
func add_to_Inventory():
	addItem.emit()
