extends Button

func _on_Get_Out_mouse_entered():
	$Sprite.modulate.r = 0.5
	$Sprite.modulate.g = 0.5
	$Sprite.modulate.b = 0.5
	pass # Replace with function body.


func _on_Get_Out_mouse_exited():
	$Sprite.modulate.r = 0.1
	$Sprite.modulate.g = 0.1
	$Sprite.modulate.b = 0.1
	pass # Replace with function body.


func _on_Get_Out_pressed():
	$Sprite.modulate.r = 0.1
	$Sprite.modulate.g = 0.1
	$Sprite.modulate.b = 0.1
	get_tree().quit()
	pass # Replace with function body.
