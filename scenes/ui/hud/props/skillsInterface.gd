extends Control




onready var energy_bar = get_parent().get_node("BarStatus/StaminaBar/MarginContainer/Label/TextureProgress")


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var energyValue = energy_bar.value

	get_node(skill(1)).value = setSkillValue(210, energyValue)
	get_node(skill(2)).value = setSkillValue(180, energyValue)
	get_node(skill(3)).value = setSkillValue(350, energyValue)
	get_node(skill(4)).value = setSkillValue(100, energyValue)
	get_node(skill(5)).value = setSkillValue(200, energyValue)
	
	
	changeModulate("attack_one", capt(1), Color(0,1,0.93))
	changeModulate("attack_two", capt(2), Color(0.96,0.35,0.21))
	changeModulate("attack_three", capt(3), Color(0.87,0,0))
	changeModulate("lifeUp", capt(4), Color(0,0.87,0.87))
	changeModulate("roll", capt(5), Color(0.27,0.99,0.26))

func skill(num):
	return "skill"+ str(num) +"/skill"+ str(num)
func capt(num):
	return "skill"+str(num)+"/caption"+ str(num)

func WhiteModulate(node):
	get_node(node).modulate = Color(1,1,1)


func changeModulate(action, node, color):
	if Input.is_action_pressed(action):
		get_node(node).modulate = color
	if !Input.is_action_pressed(action):
		WhiteModulate(node)

func setSkillValue(value, energyValue):
	
	var newValue = value - energyValue
	
	if newValue < 0:
		newValue = 0
	return  newValue


func _on_skill1_pressed():
	Input.action_press("attack_one")

func _on_skill2_pressed():
	Input.action_press("attack_two")
	
func _on_skill3_pressed():
	Input.action_press("attack_three")

func _on_skill4_pressed():
	Input.action_press("lifeUp")

func _on_skill5_pressed():
	Input.action_press("roll")
	



func _on_skill1_mouse_exited():
	Input.action_release("attack_one")
	
func _on_skill2_mouse_exited():
	Input.action_release("attack_two")

func _on_skill3_mouse_exited():
	Input.action_release("attack_three")

func _on_skill4_mouse_exited():
	Input.action_release("lifeUp")

func _on_skill5_mouse_exited():
	Input.action_release("roll")
