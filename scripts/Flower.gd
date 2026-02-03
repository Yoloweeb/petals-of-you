extends Node2D

@export var stages: Array[Texture2D] = []   # assign 3 textures in Inspector (temp is fine)
@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D

var stage_idx := 0
var watering := false
var hold := 0.0
var current_player: Node = null
var delivery_in_progress := false
const HOLD_REQUIRED := 2.0  # seconds holding E

func _ready() -> void:
	if stages.size() > 0:
		sprite.texture = stages[stage_idx]
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if delivery_in_progress:
		return
	if watering and current_player and current_player.get("carrying_water") and Input.is_action_pressed("interact"):
		hold += delta
		if hold >= HOLD_REQUIRED:
			delivery_in_progress = true
			_get_level_controller().process_water_delivery(current_player)
			hold = 0.0
	else:
		hold = max(0.0, hold - delta * 0.5)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		current_player = body
		watering = true

func _on_body_exited(body: Node) -> void:
	if body == current_player:
		current_player = null
		watering = false

func _get_level_controller() -> Node:
	return get_node("../LevelController")

func pulse_subtle() -> void:
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(sprite, "scale", Vector2(1.06, 1.06), 0.18)
	tw.tween_property(sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.18)
	tw.set_parallel(false)
	tw.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.22)

func bloom_big() -> void:
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.35)
	tw.tween_property(sprite, "modulate", Color(1.0, 0.98, 0.85, 1.0), 0.35)
