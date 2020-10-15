extends KinematicBody2D


const  MOTION_SPEED = 230
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
var death_state = false

var energy_max_value = 1000.0
var health_max_value = 1000.0
var vel_roll = Vector2(0,0)



func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y)/1.7 )

func _on_Timer_timeout():
	in_roll = false
	speed = MOTION_SPEED

func _physics_process(delta):
	if (death_state == false):
		var motion = Vector2()
		
		
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


		if Input.is_action_pressed("roll") and in_roll == false and motion != Vector2(0, 0) and energy_bar.value >= 200 :
			if(energy_bar.value != 0):
				in_roll = true
				energy_max_value = round(energy_max_value - 200.0)
				speed = 450
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
			
			idle = "idle_" + direction_animation
			roll = "roll_" + direction_animation
			run = "run_" + direction_animation

			_position_last_frame = position
	

	
	
			if in_roll == false:
				$AnimatedSprite.play(run)
			else:
				$AnimatedSprite.play(roll)
				update_energy(energy_max_value)
		else:
			$AnimatedSprite.play(idle)
			energy_bar.value = energy_bar.value + 3 #idle bonus
	
		energy_bar.value = energy_bar.value + 0.6
		energy_max_value = energy_bar.value
		health_bar.value = health_bar.value + (1/10)
		health_max_value = health_bar.value
		
			


		motion = motion.normalized()
		motion = cartesian_to_isometric(motion)  * speed
		move_and_slide(motion)
	
func take_damage(damage):
	if(death_state == false):
		if(health_bar.value <= 0):
			death_state = true
			death = "death_" + direction_animation
			$AnimatedSprite.play(death)
		else:
			health_max_value = round(health_max_value - damage)
			update_health(health_max_value)
	
func update_energy(new_value):
	energy_bar.value = new_value
	
func update_health(new_value):
	health_bar.value = new_value
