# Fragment.gd (Godot 4.5)
# Attach to: Fragment (Area2D)
# Children recommended: Sprite2D (optional), CollisionShape2D

extends Area2D

## --- Designer Tweaks ---
@export var order_index: int = 0                 # Used when sequence is enforced by PuzzleController
@export var start_hidden: bool = false           # For hidden-path/beacon reveal variant
@export var float_amp: float = 4.0               # Vertical bob amplitude (pixels)
@export var float_speed: float = 1.2             # Vertical bob speed (radians/sec)
@export var collect_scale_boost: float = 1.25    # Scale up briefly on collect
@export var collect_fade_time: float = 0.18      # Fade-out duration on collect
@export var reject_flash_low_alpha: float = 0.3  # Low alpha for “wrong order” feedback
@export var reject_flash_in: float = 0.08        # Fade to low alpha
@export var reject_flash_out: float = 0.10       # Fade back to full alpha

## Optional SFX hooks (set via inspector or leave empty)
@export var sfx_collect: AudioStream
@export var sfx_reject: AudioStream

## Internal
var _controller: Node = null
var _base_y: float = 0.0
var _t: float = 0.0

func register_to_controller(ctrl: Node) -> void:
	"""
	Called by PuzzleController in _ready() to register each fragment.
	"""
	_controller = ctrl
	set_process(true)

func _ready() -> void:
	_base_y = position.y
	if start_hidden:
		visible = false

	# Ensure we detect the player (CharacterBody2D) via physics overlap
	# Area2D signal for physics body:
	connect("body_entered", Callable(self, "_on_body_entered"))

	# (Optional) Preload SFX player dynamically if clips are provided
	if sfx_collect or sfx_reject:
		# Keep a tiny AudioStreamPlayer2D around if needed
		if not has_node("SFX"):
			var p := AudioStreamPlayer2D.new()
			p.name = "SFX"
			add_child(p)

func _process(delta: float) -> void:
	# Gentle float motion
	_t += delta
	position.y = _base_y + sin(_t * float_speed) * float_amp

func _on_body_entered(body: Node) -> void:
	# Require player group to avoid NPCs/other bodies
	if not body.is_in_group("player"):
		return

	# If no controller, just disappear gracefully (failsafe)
	if _controller == null or not is_instance_valid(_controller):
		_collect_and_fade()
		return

	# Ask the controller if we can be collected (sequence gating, etc.)
	if _controller.has_method("try_collect") and _controller.try_collect(order_index):
		_collect_and_fade()
	else:
		_reject_flash()

func _reject_flash() -> void:
	# Optional reject SFX
	_play_sfx(sfx_reject)

	# Flash transparency briefly to signal wrong order
	var tw = create_tween()
	tw.tween_property(self, "modulate:a", reject_flash_low_alpha, reject_flash_in)
	tw.tween_property(self, "modulate:a", 1.0, reject_flash_out)

func _collect_and_fade() -> void:
	# Optional collect SFX
	_play_sfx(sfx_collect)

	# Scale up slightly and fade out, then free
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(self, "scale", Vector2(collect_scale_boost, collect_scale_boost), collect_fade_time * 0.66)
	tw.tween_property(self, "modulate:a", 0.0, collect_fade_time)
	tw.set_parallel(false)
	tw.tween_callback(Callable(self, "queue_free"))

func _play_sfx(stream: AudioStream) -> void:
	if not stream:
		return
	var p: AudioStreamPlayer2D = get_node_or_null("SFX")
	if p:
		p.stream = stream
		p.play()
