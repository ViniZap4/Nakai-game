extends KinematicBody2D

var speed = 7
var maxHealth = 100
var enemyDamage = 25

var ai_think_time = 0.7
var ai_think_time_timer = null

var direction_animation = "sd"
var idle = "idle"
var run = "run"

var reflexes = 4
onready var target = get_parent().get_node("nakai")
var is_in_range = false

var health = 0

func _onready():
	health = maxHealth;
	setup_ai_think_time_timer()

func _ready():
	_onready()
	setup_ai_think_time_timer()

func take_Damage(damageCount):
	health -= damageCount;
	
	if(health <= 0):
		health = 0
		$AnimationPlayer.play("death_a")
		queue_free()
		
		
func attack():
	var damage = round(randi() % 50 + enemyDamage / 10)
	target.take_damage(damage);

func ai_get_direction():
	return target.position - self.position


func ai_move():
	var direction = ai_get_direction() 
	var motion = direction.normalized() * speed
	
	if motion <= Vector2( -5  , -3) and motion >= Vector2( -6  , -4):
		direction_animation = "a"
	if motion <= Vector2( 6  , -1 ) and motion >= Vector2( 5  , 0):
		direction_animation = "d"
	if motion >= Vector2( -1  , -7 ) and motion <= Vector2( 1  , -5):
		direction_animation = "w"
	if motion >= Vector2( -1  , 7 ) and motion <= Vector2( 0  , 5):
		direction_animation = "s"
	
	if motion >= Vector2( -6  , -4 ) and motion <= Vector2( -3  , -2):
		direction_animation = "wa"
	#if motion >= Vector2( -6  , -4 ) and motion <= Vector2( -3  , -2):
	#	direction_animation = "wd"
		
		
	run = "run_" + direction_animation
	
	print(motion)
	
	move_and_collide(motion);
	$AnimatedSprite.play(run); 
	
func setup_ai_think_time_timer():
	ai_think_time_timer = Timer.new()
	ai_think_time_timer.set_one_shot(true)
	ai_think_time_timer.set_wait_time(ai_think_time)
	ai_think_time_timer.connect("timeout", self, "on_ai_thinktime_timeout_complete")
	add_child(ai_think_time_timer)

func decide_to_attack():
	ai_think_time_timer.start()
	
func on_ai_thinktime_timeout_complete():
	if is_in_range:
		attack()

func _process(delta):
	if is_in_range && ai_think_time_timer.time_left == 0:
		decide_to_attack()
	else:
		ai_move()
