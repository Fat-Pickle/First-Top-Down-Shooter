extends Control

var playerHealth: int = 100
var maxPlayerHealth: int = 100

var hudReloadTime = 1

signal updateWeapon

func ready():
	set_process(false)

func _process(delta):
	var progressBarValue = $ProgressBar.get_value()
	if progressBarValue == 100.0:
		set_process(false)
	else:
		$ProgressBar.set_value(progressBarValue + (100.0 / hudReloadTime) * delta)

func updateIcons():
	# get_parent is called twice since in the main scene the player HUD is a child
	# of a Canvas Layer, which is a child of the player Character
	var currentPlayerInventory = get_parent().get_parent().playerInventory
	print("Player HUD ", currentPlayerInventory)
	
	# Checks if the slot is empty, reads it and updates the icons if It's not
	# You should verify if the textures exist
	if currentPlayerInventory["WeaponLight"]!= { }:
		var weaponLightID = currentPlayerInventory["WeaponLight"]["itemID"]
		$WeaponBar/Light/Light_Sprite.texture = load(itemLoader.allItems[weaponLightID]["itemIconPath"])
		
	if currentPlayerInventory["WeaponMedium"]!= { }:
		var weaponMediumID = currentPlayerInventory["WeaponMedium"]["itemID"]
		$WeaponBar/Medium/Medium_Sprite.texture = load(itemLoader.allItems[weaponMediumID]["itemIconPath"])
		
	if currentPlayerInventory["WeaponHeavy"]!= { }:
		var weaponHeavyID = currentPlayerInventory["WeaponHeavy"]["itemID"]
		$WeaponBar/Heavy/Heavy_Sprite.texture = load(itemLoader.allItems[weaponHeavyID]["itemIconPath"])
	
	updateWeapon.emit()
	
	updateEquippedLabel()
	
# Updates the Label displaying the name of the currently equipped weapon
func updateEquippedLabel():
	var currentPlayerWeapon = get_parent().get_parent().equipped
	$currentWeapon.text = itemLoader.allItems[currentPlayerWeapon["itemID"]]["itemName"]

# equips the selected weapon when the appropiate hotkey is pressed
# and if there is something in the slot to actually equip

func equip_weapon(weaponType: String):
	var player = get_parent().get_parent()
	
	if player.playerInventory[weaponType] != { }:
		player.equipped = player.playerInventory[weaponType]
		#print("Player equipped this: ",player.equipped)
		updateWeapon.emit()
		updateEquippedLabel()

# Rework this to use signals instead of going through the player Character
func update_ammo_hud(Magazine : int, Reserves : int):
	$Magazine.text = str(Magazine)
	$Reserves.text = str(Reserves)

func set_progress_bar_value(value : float):
	#print(value)
	$ProgressBar.set_value(value)
	set_process(false)

# set_process(true) has to at the bottom for some reason, 
# otherwise the progress bar won't move since set_process is set to false
# by set_progress_bar_value() which is really bizzare
func start_progress_bar_fill(reloadTime):
	set_progress_bar_value(0.0)
	hudReloadTime = reloadTime
	print(reloadTime)
	set_process(true)

func _on_light_pressed():
	equip_weapon("WeaponLight")
	
func _on_medium_pressed():
	equip_weapon("WeaponMedium")

func _on_heavy_pressed():
	equip_weapon("WeaponHeavy")
