extends CharacterBody2D

@export var health : int = 1

func _ready():
	$Label.text = str(health)

func on_hit(damage):
	health -= damage
	$Label.text = str(health)
