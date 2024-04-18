extends Sprite2D

#Make pick up pop up appear when approached and dissappear when player leaves collision area
func _on_area_2d_body_entered(body):
	$ColorRect.visible = true
	
func _on_area_2d_body_exited(_body):
	$ColorRect.visible = false

