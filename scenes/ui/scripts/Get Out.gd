extends Button

func _on_Get_Out_mouse_entered():
	$Sprite.modulate.r = 0.5
	$Sprite.modulate.g = 0.5
	$Sprite.modulate.b = 0.5
	pass # Replace with function body.


func _on_Get_Out_mouse_exited():
	$Sprite.modulate.r = 1
	$Sprite.modulate.g = 1
	$Sprite.modulate.b = 1
	pass # Replace with function body.


func _on_Get_Out_pressed():
	if(get_tree().paused == true):
		get_tree().paused = false
		get_owner().queue_free()
	$Sprite.modulate.r = 1
	$Sprite.modulate.g = 1
	$Sprite.modulate.b = 1
	get_tree().quit()
	pass # Replace with function body.
