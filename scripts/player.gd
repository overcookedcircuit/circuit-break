extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED 
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		velocity.x = 0
		velocity.y = SPEED
	elif Input.is_action_pressed("up"):
		velocity.x = 0
		velocity.y = -SPEED
	else:
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()
