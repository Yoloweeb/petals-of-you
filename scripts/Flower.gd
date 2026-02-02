extends Node2D

@export var stages: Array[Texture2D] = []   # assign 3 textures in Inspector (temp is fine)
@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D

var stage_idx := 0
var watering := false
var hold := 0.0
const HOLD_REQUIRED := 2.0  # seconds holding E

func _ready() -> void:
	if stages.size() > 0:
		sprite.texture = stages[stage_idx]
	area.body_entered.connect(func(_b): watering = true)
	area.body_exited.connect(func(_b): watering = false)

func _process(delta: float) -> void:
	if watering and Input.is_action_pressed("interact"):
		hold += delta
		if hold >= HOLD_REQUIRED:
			_advance()
			hold = 0.0
	else:
		hold = max(0.0, hold - delta * 0.5)

func _advance() -> void:
	if stage_idx < stages.size() - 1:
		stage_idx += 1
		sprite.texture = stages[stage_idx]
		get_node("../LevelController").call("trigger_mood_shift", true)
		if stage_idx == stages.size() - 1:
			Game.set_flag("nurtured_flower")
			get_node("../LevelController").call("show_choice",
				"Share the last drop of water?",
				"Share", "Keep",
				func(shared: bool):
					Game.set_flag("share_water", shared)
					Game.next_chapter()
			)
			
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
