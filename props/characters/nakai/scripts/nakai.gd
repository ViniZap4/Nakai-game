extends KinematicBody2D

var MOTION_SPEED = 160 

var direction = "sd"
var idle = "idle_sd"
var run = "run_sd"
var roll = "idle_sd"

var in_roll = false
var vel_roll = Vector2(0,0)

func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y)/1.7 )

func _on_Timer_timeout():
	in_roll = false
	MOTION_SPEED = 160

func _physics_process(delta):
	var motion = Vector2()

	
	if Input.is_action_pressed("move_up") and Input.is_action_pressed("move_left") and in_roll == false:
		direction = "wa"
		
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right") and in_roll == false:
		direction = "wd"
		
	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_left") and in_roll == false:
		direction = "sa"

	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_right") and in_roll == false:
		direction = "sd"
		
	elif Input.is_action_pressed("move_up") and in_roll == false:
		direction = "w"
		
	elif Input.is_action_pressed("move_down") and in_roll == false:
		direction = "s"
		
	elif Input.is_action_pressed("move_left") and in_roll == false:
		direction = "a"
		
	elif Input.is_action_pressed("move_right") and in_roll == false:
		direction = "d"
		
	
	idle = "idle_" + direction
	roll = "roll_" + direction
	run = "run_" + direction
	
	
	
	
	
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
		in_roll = true
		MOTION_SPEED = 360 
		vel_roll = motion
		
		$Timer.connect("timeout", self, "_on_Timer_timeout")
		$Timer.start()

	
	
	if motion !=  Vector2(0, 0): 
		if in_roll == false:
			$AnimatedSprite.play(run)
		else:
			$AnimatedSprite.play(roll)
	else:
		$AnimatedSprite.play(idle)

	print(vel_roll) 

	motion = motion * MOTION_SPEED
	motion = cartesian_to_isometric(motion)
	move_and_slide(motion)
