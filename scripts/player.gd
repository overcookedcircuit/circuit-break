extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var current_dir = "none"


func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_animation(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		play_animation(1)
		velocity.x = -SPEED 
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		velocity.x = 0
		velocity.y = SPEED
	elif Input.is_action_pressed("up"):
		velocity.x = 0
		velocity.y = -SPEED
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func play_animation(movement):
	var dir = current_dir
	var animation = $AnimatedSprite2D
	
	if dir == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("walking")
		elif movement == 0:
			animation.play("idle")
	if dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("walking")
		elif movement == 0:
			animation.play("idle")
