extends Control


func _ready():
	pass # Replace with function body.


func update_percent(new_percent):
	$LoadTween.interpolate_property($LoadingBar, "value", $LoadingBar.value, new_percent, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$LoadTween.start()

	yield($LoadTween, "tween_completed")

	if new_percent == $LoadingBar.max_value:
		#$LoadScreenAnim.play("hide")
		get_tree().change_scene("res://scenes/Kingdoms/TraoriGrindolynGrindohr/TraoriGrindolynGrindohr.tscn")
