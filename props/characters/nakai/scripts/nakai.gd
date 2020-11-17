extends KinematicBody2D


const  MOTION_SPEED = 230
var speed = MOTION_SPEED

var direction_animation = "sd"
var idle = "idle_sd"
var run = "run_sd"
var death = "death"
var roll = "idle_sd"
var attack = "attack_sd"
var damage = 0;
var attack_type = 0;
var _position_last_frame := Vector2()
var _cardinal_direction = 0
onready var energy_bar = get_parent().get_node("nakai/Camera2D/GUI/BarStatus/StaminaBar/MarginContainer/Label/TextureProgress")
onready var health_bar = get_parent().get_node("nakai/Camera2D/GUI/BarStatus/HealthBar/MarginContainer/Label/TextureProgress")
onready var target = get_parent().get_node("warrior")
var is_roll = false
var is_attack = false;
var death_state = false
var energy_discaunt = false

var energy_max_value = 1000.0
var health_max_value = 1000.0
var vel_roll = Vector2(0,0)
var energy = null;
var cure = null;
var damage_caused = null;
var attacked = false;

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y)/1.7 )

func _on_Timer_timeout():
	is_roll = false
	speed = MOTION_SPEED

func _on_Timer_attack_timeout():
	is_attack = false
	attacked = false

func _physics_process(delta):
	if (death_state == false):
		var motion = Vector2()
		
		if Input.is_action_pressed("move_up") and is_roll == false and is_attack == false:
			motion += Vector2(-1, -1)
					
		if Input.is_action_pressed("move_down") and is_roll == false and is_attack == false:
			motion += Vector2(1, 1)

		if Input.is_action_pressed("move_left") and is_roll == false and is_attack == false:
			motion += Vector2(-1, 1)
			
		if Input.is_action_pressed("move_right") and is_roll == false and is_attack == false:
			motion += Vector2(1, -1)
		
		if is_roll == true:
			motion += vel_roll

		if Input.is_action_just_pressed("roll"):
			if(energy_bar.value >= 200.0):
				is_roll = true
				energy_discaunt = true
				energy_max_value = round(energy_max_value - 200)
				speed = 310
				vel_roll = motion
				$Timer.connect("timeout", self, "_on_Timer_timeout")
				$Timer.start()
		
		if Input.is_action_just_pressed("attack_one") and (energy_bar.value >= 210):
			attack_type = 1;
			is_attack = true
			energy = 210;
			damage_caused = 340;
			energy_max_value = round(energy_max_value - energy)
			update_energy(energy_max_value)
			$Timer_attack.wait_time = 1.5
			init_timer_attack()
				
		if Input.is_action_just_pressed("attack_two") and (energy_bar.value >= 180):
			attack_type = 2;
			is_attack = true
			energy = 180
			damage_caused = 280
			energy_max_value = round(energy_max_value - energy)
			update_energy(energy_max_value)
			$Timer_attack.wait_time = 1
			init_timer_attack()
				
		if Input.is_action_just_pressed("attack_tree") and (energy_bar.value >= 350):	
			attack_type = 3;
			is_attack = true
			energy = 350
			damage_caused = 450
			energy_max_value = round(energy_max_value - energy)
			update_energy(energy_max_value)
			$Timer_attack.wait_time = 1.90
			init_timer_attack()
						
		if Input.is_action_just_pressed("lifeUp") and (energy_bar.value >= 100):	
			energy = 100
			energy_max_value = round(energy_max_value - energy)
			update_energy(energy_max_value)
			cure = 120
			health_max_value = round(health_max_value + cure)			
			update_health(health_max_value)
			
		if(Input.is_action_just_pressed("ui_pause")):
			get_tree().change_scene("res://scenes/ui/pause/pause.tscn")
		

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
			attack = "attack" + str(attack_type) + "_" + direction_animation

			_position_last_frame = position
			
			if(is_attack == false):
				if is_roll == false:
					$AnimatedSprite.play(run)
				else:
					$AnimatedSprite.play(roll)
					if(energy_discaunt == true):
						#print(energy_max_value)
						update_energy(energy_max_value)
						energy_discaunt = false
		
		else:
			if(is_attack == true):
				$AnimatedSprite.play(attack)
				attack()
			else:
				$AnimatedSprite.play(idle)
				energy_bar.value = energy_bar.value + 0.9 #idle bonus
	


		energy_bar.value = energy_bar.value + 0.5
		energy_max_value = energy_bar.value

		
		if(energy_bar.value == 1000): 
			regen_life()

	
		if(is_attack == false):
			motion = motion.normalized()
			motion = cartesian_to_isometric(motion)  * speed
			move_and_slide(motion)
	else:
		if($AnimatedSprite.frame == 32 and death_state == true):
			get_tree().change_scene("res://scenes/ui/game-over/Game Over.tscn")

func take_damage(damage):
	if(death_state == false):
		if(health_bar.value <= 10):
			death_state = true
			death = "death_" + direction_animation
			$AnimatedSprite.play(death)

		else:
			health_max_value = round(health_max_value - damage)
			update_health(health_max_value)
	
func update_energy(new_value):
	energy_bar.value = new_value
	
func update_health(new_value):
	if (new_value >= 10000):
		new_value = 10000
	health_bar.value = new_value
	print(health_bar.value)
	health_max_value = health_bar.value
	
func regen_life():
	health_bar.value = health_bar.value + 0.06
	health_max_value = health_bar.value

func init_timer_attack():		
	$Timer_attack.connect("timeout", self, "_on_Timer_attack_timeout")
	$Timer_attack.start()

func attack():
	damage = damage_caused;
	if(target != null):
		var direction = target.direction
		var distance_direction = sqrt(direction.x * direction.x + direction.y * direction.y)
		var ready_to_attack = ($AnimatedSprite.frame == 17 || $AnimatedSprite.frame == 18 || $AnimatedSprite.frame == 19  || $AnimatedSprite.frame == 20  || $AnimatedSprite.frame == 21  || $AnimatedSprite.frame == 22  || $AnimatedSprite.frame == 23  || $AnimatedSprite.frame == 24) and distance_direction < 100 and attacked == false
		if(ready_to_attack == true):
			target.take_Damage(damage)
			update_energy(energy_max_value)
			attacked = true
			_on_Timer_attack_timeout()
		
func _continue():
	get_tree().paused = false
	$Camera2D/Popup.hide()
	
func setTarget(obj):
	if(target.get_instance_id() != obj.get_instance_id()):
		var name = obj.name
		#print("Novo alvo setado: " + name)
		target = get_parent().get_node(name)
