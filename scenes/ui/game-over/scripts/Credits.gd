extends Button

func _on_Credits_mouse_entered():
	$Sprite.modulate.r = 0.5
	$Sprite.modulate.g = 0.5
	$Sprite.modulate.b = 0.5
	pass # Replace with function body.


func _on_Credits_mouse_exited():
	$Sprite.modulate.r = 1
	$Sprite.modulate.g = 1
	$Sprite.modulate.b = 1
	pass # Replace with function body.


func _on_Credits_pressed():
	$Sprite.modulate.r = 0.1
	$Sprite.modulate.g = 0.1
	$Sprite.modulate.b = 0.1
	get_tree().change_scene("Credits.tscn")
	pass # Replace with function body.
