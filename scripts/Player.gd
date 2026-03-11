extends CharacterBody2D

const SPEED := 180.0
const JUMP_VELOCITY := -320.0
const GRAVITY := 900.0
const charge_time_max := 0.6
const bloom_jump_velocity_min := JUMP_VELOCITY * 1.15
const bloom_jump_velocity_max := JUMP_VELOCITY * 2

var carrying_water := false
var is_charging_bloom_jump := false
var bloom_charge_time := 0.0

func set_carrying_water(v: bool) -> void:
	carrying_water = v

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		if is_charging_bloom_jump:
			is_charging_bloom_jump = false
			bloom_charge_time = 0.0
			UiRoot.hud_clear_bloom_jump_charge()
	else:
		velocity.y = 0.0  # reset vertical velocity when grounded

	# Horizontal movement
	var dir := 0.0
	if Input.is_action_pressed("move_left"):
		dir -= 1.0
	if Input.is_action_pressed("move_right"):
		dir += 1.0
	velocity.x = dir * SPEED

	if Global.has_bloom_jump:
		if Input.is_action_just_pressed("bloom_jump") and is_on_floor():
			is_charging_bloom_jump = true
			bloom_charge_time = 0.0

		if is_charging_bloom_jump and Input.is_action_pressed("bloom_jump"):
			bloom_charge_time = min(bloom_charge_time + delta, charge_time_max)
			UiRoot.hud_set_bloom_jump_charge(bloom_charge_time / charge_time_max)

		if Input.is_action_just_released("bloom_jump"):
			if is_charging_bloom_jump and is_on_floor():
				var charge_ratio: float = bloom_charge_time / charge_time_max if charge_time_max > 0.0 else 1.0
				velocity.y = lerp(bloom_jump_velocity_min, bloom_jump_velocity_max, charge_ratio)
				print("Bloom Jump! charge=", snapped(charge_ratio, 0.01))
				UiRoot.hud_clear_bloom_jump_charge()

			is_charging_bloom_jump = false
			bloom_charge_time = 0.0

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()
