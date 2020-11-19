extends Button

func _on_Restart_mouse_entered():
	$Sprite.modulate.r = 0.5
	$Sprite.modulate.g = 0.5
	$Sprite.modulate.b = 0.5
	pass # Replace with function body.


func _on_Restart_mouse_exited():
	$Sprite.modulate.r = 1
	$Sprite.modulate.g = 1
	$Sprite.modulate.b = 1
	pass # Replace with function body.


func _on_Restart_pressed():
	if(get_tree().paused == true):
		get_tree().paused = false
		get_owner().queue_free()
	$Sprite.modulate.r = 0.1
	$Sprite.modulate.g = 0.1
	$Sprite.modulate.b = 0.1
	get_tree().change_scene("res://scenes/ui/load/load.tscn")
	pass # Replace with function body.