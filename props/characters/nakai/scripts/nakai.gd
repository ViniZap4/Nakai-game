extends KinematicBody2D

const  MOTION_SPEED = 240

var speed = MOTION_SPEED

var direction_animation = "sd"
var idle = "idle_sd"
var run = "run_sd"
var roll = "idle_sd"
var _position_last_frame := Vector2()
var _cardinal_direction = 0

var in_roll = false
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
		in_roll = true
		speed = 468 
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
			$AnimatedSprite.play(roll)
	else:
		$AnimatedSprite.play(idle)


	motion = motion.normalized() * speed
	motion = cartesian_to_isometric(motion)
	move_and_slide(motion)
