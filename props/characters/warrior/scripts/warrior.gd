extends KinematicBody2D

var speed = 4.5
var maxHealth = 1000.0
var enemyDamage = 60.0

var ai_think_time = 0.7
var ai_think_time_timer = null


#animacoes
var motion_direction
var direction_animation = "sd"
var idle = "idle"
var death = "death"
var run = "run"
var attack = "attack"
var _position_last_frame := Vector2()
var _cardinal_direction = 0

var reflexes = 4
onready var target = get_parent().get_node("nakai")
onready var health = get_parent().get_node("warrior/TextureProgress")
var is_in_range = false

func _onready():
	health.value = maxHealth;
	setup_ai_think_time_timer()

func _ready():
	_onready()
	setup_ai_think_time_timer()

func take_Damage(damageCount):
	health.value -= damageCount;
	
	if(health.value <= 0):
		$AnimatedSprite.play(death)

func ai_get_direction():
	return target.position - self.position


func ai_move():
	if(target.death_state == false):
		
		var direction = ai_get_direction() 
		var motion = direction.normalized() * speed
		$AnimatedSprite.play(run);
		
		move_and_collide(motion);

#diresao
func _physics_process(delta):
	if(target.death_state == false and health.value > 0):
		motion_direction = position - _position_last_frame

		if motion_direction.length() > 0.0001:
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
				
		run = "run_" + direction_animation
		attack = "attack_" + direction_animation
		idle = "idle_" + direction_animation
		death = "death_" + direction_animation
		_position_last_frame = position
	

func setup_ai_think_time_timer():
	ai_think_time_timer = Timer.new()
	ai_think_time_timer.set_one_shot(true)
	ai_think_time_timer.set_wait_time(ai_think_time)
	ai_think_time_timer.connect("timeout", self, "on_ai_thinktime_timeout_complete")
	add_child(ai_think_time_timer)

func decide_to_attack():
	ai_think_time_timer.start()

func _process(delta):
	
	var direction = ai_get_direction()
	var distance_direction = sqrt(direction.x * direction.x + direction.y * direction.y)


	if(distance_direction < 500):


		#if(distance_direction <= 98): motion_direction
		if(health.value > 0):
			if(distance_direction <= 98) and motion_direction <= Vector2(0.9,0.9) and motion_direction >= Vector2(-0.9,-0.9):
				if(target.death_state == false):
					$AnimatedSprite.play(attack);
					if($AnimatedSprite.frame == 13): 
						target.take_damage(enemyDamage)
				else:
					$AnimatedSprite.play(idle);
			else:
				ai_move()

	else:
		if(health.value > 0):
			$AnimatedSprite.play(idle);
