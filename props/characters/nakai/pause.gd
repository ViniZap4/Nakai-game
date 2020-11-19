extends Node

onready var target = "res://props/characters/nakai/nakai.tscn"


func _ready():
	$Content.visible = true

func _process(delta):
	
	if(Input.is_action_just_pressed("ui_pause")):
		if(get_tree().paused == false):
			get_tree().paused = true;
			get_parent().get_node("GUI").visible = false
		else:
			$Content.visible = false;
