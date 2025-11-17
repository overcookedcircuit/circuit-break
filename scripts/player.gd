extends CharacterBody2D
@export var bullet_scene: PackedScene
@export var shoot_cooldown := 0.7 # seconds between shots

var can_shoot = true
var is_shooting = false
const WALK_SPEED = 150.0
const JUMP_VELOCITY = -400.0
const RUN_SPEED = 300.0
const GRAVITY = 1200.0

var current_dir = "none"
var is_running = false

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	player_movement(delta)
	if Input.is_action_just_pressed("shoot"):
		shoot_bullet()


func player_movement(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		# Snap to floor
		velocity.y = 0

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
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		play_animation(2)
	
	
	move_and_slide()

func play_animation(movement):
	if is_shooting:
		velocity = Vector2.ZERO  # <-- important
		move_and_slide()
		return  # don't override shooting animation
	
	var dir = current_dir
	var animation = $AnimatedSprite2D
	
	if dir == "right":
		animation.flip_h = false
	elif dir == "left":
		animation.flip_h = true	

	if not is_on_floor():
			animation.play("jumping", 1.5)
			return

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

	# Hard stop
	velocity = Vector2.ZERO
	move_and_slide()

	# Play shooting animation
	$AnimatedSprite2D.play("shoot")

	# Delay to sync with animation muzzle flash
	await get_tree().create_timer(1.00).timeout  # adjust to match your animation frame

	# Spawn bullet
	var bullet = bullet_scene.instantiate()
	var offset = Vector2(25, 0)
	if current_dir == "left":
		offset.x *= -1
	bullet.position = global_position + offset

	if current_dir == "left":
		bullet.scale.x = -1
		bullet.speed *= -1

	get_parent().add_child(bullet)

	# Wait until animation ends
	await $AnimatedSprite2D.animation_finished

	is_shooting = false

	# Cooldown after animation
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true
