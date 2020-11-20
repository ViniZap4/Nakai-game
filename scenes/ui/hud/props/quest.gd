extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setProgressMax():
	$Quest/ProgressBar.max_value += 1
 
func setProgressVal():
	$Quest/ProgressBar.value += 1
	if $Quest/ProgressBar.value == $Quest/ProgressBar.max_value:
		get_tree().change_scene("res://scenes/ui/credits/Credits.tscn")


func _on_ProgressQuest_mouse_entered():
	$AnimationPlayer.play("open")


func _on_ProgressQuest_mouse_exited():
	$AnimationPlayer.play("close")
