extends Node

# This is going to be the base class from which all Levels will inherit
# It manages all spawns 

var levelName : String = ""

func _ready():
	levelName = "Level1"
	print(levelName)

# This doesn't do anything, but I need it since rigid body on hit signal can't
# be set to ignore bodies on specific layers, unless I'm wrong
func on_hit(_damage):
	pass
