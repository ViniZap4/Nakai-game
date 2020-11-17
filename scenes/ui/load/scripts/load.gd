extends Node

onready var loadingbar = $UI/LoadingbarScreen
var level_thread = Thread.new()
var load_percent = 0

func _ready():

	load_game()


func load_game():
#	var scene = load("res://scenes/Kingdoms/TraoriGrindolynGrindohr/TraoriGrindolynGrindohr.tscn")

	#add_child(scene.instance())
	level_thread.start(self, "build_level", null, 1)
	setup_character()

func setup_character():
	load_percent += 50
	$UI/LoadingScreen.update_percent(load_percent)


	
func build_level(empty):
	load_percent += 50

	$UI/LoadingScreen.update_percent(load_percent)


	level_thread.wait_to_finish()
