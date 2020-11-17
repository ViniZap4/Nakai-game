extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible = false


func _process(delta):
	
	if(Input.is_action_just_pressed("ui_pause")):
		if(get_tree().paused == false):
			get_tree().paused = true;
			$Label.visible = true;
		else:
			get_tree().paused = false;
			$Label.visible = false;
