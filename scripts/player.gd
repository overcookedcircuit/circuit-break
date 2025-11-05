extends CharacterBody2D
@export var bullet_scene: PackedScene
@export var shoot_cooldown := 0.7 # seconds between shots

var can_shoot = true
var is_shooting = false
const WALK_SPEED = 150.0
const JUMP_VELOCITY = -400.0
const RUN_SPEED = 300.0

var current_dir = "none"
var is_running = false

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	player_movement(delta)
	if Input.is_action_just_pressed("shoot"):
		shoot_bullet()


func player_movement(delta):
	is_running = Input.is_action_pressed("shift")
	if is_shooting:
		move_and_slide()
		return
	
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
	if is_shooting:
		return  # don't override shooting animation
	
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

func shoot_bullet():
	if not can_shoot or bullet_scene == null:
		return
	
	can_shoot = false
	is_shooting = true
	
	# Play animation and wait for it to finish
	$AnimatedSprite2D.play("shoot")
	# Small delay to sync with the animation
	await get_tree().create_timer(1.2).timeout
	
	# Spawn bullet immediately
	var bullet = bullet_scene.instantiate()
	var offset = Vector2(25, 0)
	if current_dir == "left":
		offset.x *= -1
	bullet.position = global_position + offset
	if current_dir == "left":
		bullet.scale.x = -1
		bullet.speed *= -1
	get_parent().add_child(bullet)
	
	# Wait for animation to finish before moving again
	await $AnimatedSprite2D.animation_finished
	is_shooting = false

	# Then start cooldown
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true
