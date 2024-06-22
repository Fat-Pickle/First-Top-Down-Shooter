extends Sprite2D

#var equipped : String = ""
var readyToFire = true
var projectileScene: PackedScene = preload("res://Assets/Weapons/Bullet.tscn")

var weaponDamage : int = 0
var weaponAccuracy : int = 100
var weaponVelocity : float = 800
var isBouncy : bool = false
var maxMagCapacity : int = 0
var maxReserveCapacity : int = 0
var weaponType : String = ""

# Currently equipped playerInventory weapon, used to easily access magazine capacity and reserves
# Gets assigned in update_weapon()
var playerWeapon

# These signals are used solely to connect the weapon to the player HUD
signal setProgressBarValue(value : float)
signal reload(reloadTime : float)
signal updateAmmoDisplay(Magazine : int, Reserves : int)

var isPlayerControlled = false

func _ready():
	if get_parent().name.contains("Player"):
		isPlayerControlled = true

# Updates the weapon stat based what Item is equipped by the player Character
func update_weapon():
	var weaponInfo = itemLoader.allItems[get_parent().equipped["itemID"]]
	
	$ReloadTimer.stop()
	
	weaponType = weaponInfo["itemType"]
	weaponDamage = weaponInfo["damage"]
	weaponAccuracy = weaponInfo["accuracy"]
	isBouncy = weaponInfo["isBouncy"]
	maxMagCapacity = weaponInfo["magSize"]
	maxReserveCapacity = weaponInfo["reserveCapacity"]
	
	$ReloadTimer.wait_time = weaponInfo["reloadTime"]/10.0
	$ShotDelay.wait_time = 1.0/(float(weaponInfo["rateOfFire"])/60.0)
	texture = load(weaponInfo["itemSpritePath"])
	
	playerWeapon = get_parent().playerInventory[weaponType]
	
	# Sets the reload progress bar
	if playerWeapon["MagazineAmmo"] > 0:
		setProgressBarValue.emit(( float(playerWeapon["MagazineAmmo"]) / float(maxMagCapacity)) * 100.0)
	else:
		setProgressBarValue.emit(0.0)
	
	updateAmmoDisplay.emit(playerWeapon["MagazineAmmo"],playerWeapon["ReserveAmmo"])
	print($ShotDelay.wait_time)

func reload_weapon():
	print("Reloading")
	if playerWeapon["ReserveAmmo"] > 0 and $ReloadTimer.is_stopped():
		setProgressBarValue.emit(0.0)
		reload.emit($ReloadTimer.wait_time)
		# Starting a timer also resets it
		$ReloadTimer.start()
	else:
		print("No reserve ammo left")

# shoots the gun when It's not on cooldown
func fire_weapon():
	
	if readyToFire and playerWeapon["MagazineAmmo"] > 0:
		
		$ReloadTimer.stop()
		
		if isBouncy:
			shoot_bullet()
		else:
			fire_raycast_shot()
		
		playerWeapon["MagazineAmmo"] -= 1
		
		if playerWeapon["MagazineAmmo"] <= 1 :
			setProgressBarValue.emit(0.0)
		else:
			setProgressBarValue.emit(( float(playerWeapon["MagazineAmmo"]) / float(maxMagCapacity)) * 100.0 )
	
		updateAmmoDisplay.emit(playerWeapon["MagazineAmmo"],playerWeapon["ReserveAmmo"])
		readyToFire = false
		$ShotDelay.start()

# Fires a raycast ray, used by regular bullet weapons 
func fire_raycast_shot():
	#beginning of raycast
	var space_state = get_world_2d().direct_space_state
	var bulletRotation = get_parent().rotation
	# How long the raycast is, we also rotate it so that it goes the correct way
	var rayRange = global_position + Vector2(10000,0).rotated(bulletRotation)
	
	# the hexadecimal at the end is the collision mask layer, 
	# It's set to only collide with objects on the second collision mask layer
	var query = PhysicsRayQueryParameters2D.create(global_position, rayRange, 0x0002 )
	query.exclude = [get_parent(), self]
	var result = space_state.intersect_ray(query)
	
	# Check if It actually hit anything
	if result != { }:
		result["collider"].on_hit(weaponDamage)
	
# Fires an instance of a rigid body bullet
func shoot_bullet():
	# Get the rotation of current character in order to rotate the bullet the correct way
	var bulletRotation = get_parent().rotation
	var Bullet = projectileScene.instantiate()
	
	Bullet.damage = weaponDamage
	Bullet.linear_velocity = Vector2(weaponVelocity, 0.0).rotated(bulletRotation)
	
	add_child(Bullet)

func _on_shot_delay_timeout():
	readyToFire = true
	
func _on_reload_timer_timeout():
	var spentAmmo = maxMagCapacity - playerWeapon["MagazineAmmo"]
	
	# If reloading doesn't deplete reserves, subtract magazine size from reserves
	# Else Load all reserve ammo into the magazine and set the reserves to 0
	if playerWeapon["ReserveAmmo"] - spentAmmo >= 0:
		playerWeapon["ReserveAmmo"] -= spentAmmo
		playerWeapon["MagazineAmmo"] = maxMagCapacity
	else:
		playerWeapon["MagazineAmmo"] += playerWeapon["ReserveAmmo"]
		playerWeapon["ReserveAmmo"] = 0
	
	updateAmmoDisplay.emit(playerWeapon["MagazineAmmo"],playerWeapon["ReserveAmmo"])
	
	print("Reloaded")
