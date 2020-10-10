extends KinematicBody2D

const  MOTION_SPEED = 240

var speed = MOTION_SPEED

var direction_animation = "sd"
var idle = "idle_sd"
var run = "run_sd"
var death = "death"
var roll = "idle_sd"
var _position_last_frame := Vector2()
var _cardinal_direction = 0
onready var energy_bar = get_parent().get_node("nakai/Camera2D/GUI/HBoxContainer/VBoxContainer/MarginContainer2/MarginContainer/StaminaBar/MarginContainer/Label/TextureProgress")
onready var health_bar = get_parent().get_node("nakai/Camera2D/GUI/HBoxContainer/VBoxContainer/MarginContainer2/MarginContainer/HealthBar/MarginContainer/Label/TextureProgress")
var in_roll = false
var energy_max_value = 100.0
var vel_roll = Vector2(0,0)



func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y)/1.7 )

func _on_Timer_timeout():
	in_roll = false
	speed = MOTION_SPEED

func _physics_process(delta):
	var motion = Vector2()
	
		
	idle = "idle_" + direction_animation
	roll = "roll_" + direction_animation
	run = "run_" + direction_animation
	
	
	if Input.is_action_pressed("move_up") and in_roll == false:
		motion += Vector2(-1, -1)
				
	if Input.is_action_pressed("move_down") and in_roll == false:
		motion += Vector2(1, 1)

	if Input.is_action_pressed("move_left") and in_roll == false:
		motion += Vector2(-1, 1)
		
	if Input.is_action_pressed("move_right") and in_roll == false:
		motion += Vector2(1, -1)

	
	if in_roll == true:
		motion += vel_roll


	if Input.is_action_pressed("roll") and in_roll == false and motion != Vector2(0, 0):
		if(energy_bar.value != 0):
			in_roll = true
			energy_max_value = round(energy_max_value - 20.0)
			speed = 290
			vel_roll = motion
			$Timer.connect("timeout", self, "_on_Timer_timeout")
			$Timer.start()

	
	
	if motion !=  Vector2(0, 0): 
		
		var motion_direction = position - _position_last_frame
		if motion.length() > 0.0001:
			_cardinal_direction = int(8.0 * (motion_direction.rotated(PI / 8.0).angle() + PI) / TAU)


		match _cardinal_direction:
			0:
			   direction_animation = "a"
			1:
				direction_animation = "wa"
			2:
				direction_animation = "w"
			3:
			   direction_animation = "wd"
			4:
				direction_animation = "d"
			5:
				direction_animation = "sd"
			6:
				direction_animation = "s"
			7:
				direction_animation = "sa"

		_position_last_frame = position
		
		if in_roll == false:
			$AnimatedSprite.play(run)
						
		else:
			if(energy_bar.value >= 10):
				print(energy_max_value)
				update_energy(energy_max_value)
				$AnimatedSprite.play(roll)
			else:
				$AnimatedSprite.play(run)
	else:
		$AnimatedSprite.play(idle)
		energy_bar.value = energy_bar.value + 0.6
		energy_max_value = energy_bar.value

	motion = motion.normalized() * speed
	motion = cartesian_to_isometric(motion)
	move_and_slide(motion)
	
func take_damage(damage):
	if(health_bar.value <= 0):
		death = "death_" + direction_animation
		$AnimatedSprite.play(death)
	else:
		health_bar.value -= damage;
	
func update_energy(new_value):
	energy_bar.value = new_value
	
