extends Node

#stores information about every item in the game
var allItems = {}
#array with all the cfg file names
var itemCFGs = []


#Finds all .cfg files in a directory and appends them to itemCFGs array
func find_item_cfg_files(path):
	var dir = DirAccess.open(path)

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.contains(".cfg"):
				print("Found file: " + file_name)
				itemCFGs.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

#Verifies if the Item CFG section has the correct variable types
# and then saves them to a dictionary
func read_item_configs(path : String):
	var itemConfig = ConfigFile.new()
	
	var isPathOK = itemConfig.load(path)
	if isPathOK != OK:
		return
	else:
		var itemDict = {}
		for item in itemConfig.get_sections():
			#iterates over all section values and verifies if they are the corre
			for itemKeys in itemConfig.get_section_keys(item):
				var itemKeyValue = itemConfig.get_value(item, itemKeys)
				
				#checks if values are the correct types
				if itemKeys.contains("item"):
					if typeof(itemKeyValue) != TYPE_STRING:
						push_error(item, " ", itemKeys," is not a string")
						continue
				elif itemKeys.contains("is"):
					if typeof(itemKeyValue) != TYPE_BOOL:
						push_error(item, " ", itemKeys," is not a bool")
						continue
				else:
					if typeof(itemKeyValue) != TYPE_INT or itemKeyValue < 0:
						push_error(item, " ", itemKeys," is not an int")
						continue
				
				itemDict[itemKeys] = itemKeyValue
			#print(itemDict)
			allItems[itemDict["itemID"]]= itemDict
			itemDict = {}
			#print(allItems)
			
func _ready():
	find_item_cfg_files("res://Assets/Items/")
	# make it so that it doesn't use static file paths, it should iterate the files
	# found with find_item_cfg_files
	read_item_configs("res://Assets/Items/test.cfg")
	# update items so they use their proper textures
	get_tree().call_group("Items", "update_Item")
