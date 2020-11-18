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


func setSkillValue(value, energyValue):
	
	var newValue = value - energyValue
	
	if newValue < 0:
		newValue = 0
	return  newValue


func _on_skill1_pressed():
	InputMap.add_action("roll")
	print("hello")
	pass # Replace with function body.
