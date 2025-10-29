extends CharacterBody2D


const WALK_SPEED = 150.0
const JUMP_VELOCITY = -400.0
const RUN_SPEED = 300.0

var current_dir = "none"
var is_running = false

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	is_running = Input.is_action_pressed("shift")
	
	var speed = WALK_SPEED
	if is_running:
		speed = RUN_SPEED
	
	# Horizontal movement
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_animation(1)
		velocity.x = speed
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		play_animation(1)
		velocity.x = -speed
	else:
		play_animation(0)
		velocity.x = 0
	
	# Vertical movement
	if Input.is_action_pressed("up"):
		velocity.y = -speed
	elif Input.is_action_pressed("down"):
		velocity.y = speed
	else:
		velocity.y = 0
	
	
	move_and_slide()

func play_animation(movement):
	var dir = current_dir
	var animation = $AnimatedSprite2D
	
	if dir == "right":
		animation.flip_h = false
	elif dir == "left":
		animation.flip_h = true

	if movement == 1:
		if is_running:
			animation.play("running")
		else:
			animation.play("walking")
	else:
		animation.play("idle")
