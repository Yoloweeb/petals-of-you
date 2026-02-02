extends CharacterBody2D

const SPEED := 180.0
const JUMP_VELOCITY := -320.0
const GRAVITY := 900.0

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0.0  # reset vertical velocity when grounded

	# Horizontal movement
	var dir := 0.0
	if Input.is_action_pressed("move_left"):
		dir -= 1.0
	if Input.is_action_pressed("move_right"):
		dir += 1.0
	velocity.x = dir * SPEED

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()
