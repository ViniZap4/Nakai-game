extends KinematicBody2D

var MOTION_SPEED = 160 


var idle = "idle_as"
var run = "run_as"
var roll = "idle_sa"

var in_roll = false

func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y)/2 )

func _on_Timer_timeout():
	in_roll = false
	MOTION_SPEED = 160

func _physics_process(delta):
	var motion = Vector2()
	
	if Input.is_action_pressed("roll") and in_roll == false:
		in_roll = true
		MOTION_SPEED = 300 
		$Timer.connect("timeout", self, "_on_Timer_timeout")
		$Timer.start()
	
	if Input.is_action_pressed("move_up") and Input.is_action_pressed("move_left"):
		motion += Vector2(-2, 0)
		idle = "idle_wa"
		roll = "roll_wa"
		run = "run_wa" 
		
		
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right"):
		motion += Vector2(0, -2)
		idle = "idle_dw"
		roll = "roll_wd"
		run = "run_wd"
		
	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_left"):
		motion += Vector2(0, 2)
		idle = "idle_as"
		roll = "roll_sa"
		run = "run_as"

	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_right"):
		motion += Vector2(2, 0)
		idle = "idle_sd"
		roll = "roll_sd"
		run = "run_sd"
		
	elif Input.is_action_pressed("move_up"):
		motion += Vector2(-1.2, -1.2)
		idle = "idle_w"
		roll = "roll_w"
		run = "run_w"
		
	elif Input.is_action_pressed("move_down"):
		motion += Vector2(1.2, 1.2)
		idle = "idle_s"
		roll = "roll_s"
		run ="run_s"
		
	elif Input.is_action_pressed("move_left"):
		motion += Vector2(-1.2, 1.2)
		idle = "idle_a"
		roll = "roll_a"
		run = "run_a"
		
	elif Input.is_action_pressed("move_right"):
		motion += Vector2(1.2, -1.2)
		idle = "idle_d"
		roll = "roll_d"
		run = "run_d"
		
	
	if motion !=  Vector2(0, 0): 
		if in_roll == false:
			$AnimatedSprite.play(run)
		else:
			$AnimatedSprite.play(roll)
	else:
		$AnimatedSprite.play(idle)


	motion = motion * MOTION_SPEED
	motion = cartesian_to_isometric(motion)
	move_and_slide(motion)
