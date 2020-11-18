extends Control

onready var energy_bar = get_parent().get_node("BarStatus/StaminaBar/MarginContainer/Label/TextureProgress")


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var energyValue = energy_bar.value

	get_node("skill1/skill1").value = setSkillValue(210, energyValue)
	get_node("skill2/skill2").value = setSkillValue(180, energyValue)
	get_node("skill3/skill3").value = setSkillValue(350, energyValue)
	get_node("skill4/skill4").value = setSkillValue(100, energyValue)
	get_node("skill5/skill5").value = setSkillValue(100, energyValue)
	
	changeModulate("attack_one", "skill1/caption1", Color(0,1,0.93))
	changeModulate("attack_two", "skill2/caption2", Color(0.96,0.35,0.21))
	changeModulate("attack_three", "skill3/caption3", Color(0.87,0,0))
	changeModulate("lifeUp", "skill4/caption4", Color(0,0.87,0.87))
	changeModulate("roll", "skill5/caption5", Color(0.27,0.99,0.26))

func changeModulate(action, energy, node, color):
	if Input.is_action_pressed(action):
		get_node(node).modulate = color
	if !Input.is_action_pressed("attack_one"):
		get_node(node).modulate = Color(1,1,1)

func setSkillValue(value, energyValue):
	
	var newValue = value - energyValue
	
	if newValue < 0:
		newValue = 0
	return  newValue


func _on_skill1_pressed():
	Input.action_press("attack_one")
#00ffed


func _on_skill2_pressed():
	Input.action_press("attack_two")


func _on_skill3_pressed():
	Input.action_press("attack_three")


func _on_skill4_pressed():
	Input.action_press("lifeUp")


func _on_skill5_pressed():
	Input.action_press("roll")
