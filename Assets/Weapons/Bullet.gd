extends RigidBody2D

var damage : int = 1

func _on_hit(body):
	print(body," ",damage)
	body.on_hit(damage)
	queue_free()

func on_hit():
	queue_free()
