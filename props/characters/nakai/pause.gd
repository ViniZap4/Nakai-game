extends Node

onready var target = "res://props/characters/nakai/nakai.tscn"


func _ready():
	$Content.visible = true

func _process(delta):
	
	if(Input.is_action_just_pressed("ui_pause")):
		if(get_tree().paused == false):
			get_tree().paused = true;
			$Content.visible = true;
			get_parent().get_node("GUI").visible = false
		else:
			get_tree().paused = false;
			$Content.visible = false;
