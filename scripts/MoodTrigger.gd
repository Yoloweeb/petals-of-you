extends Area2D
@export var to_warmer := true

func _ready() -> void:
	body_entered.connect(func(b):
		if b is CharacterBody2D and b.name == "Player":
			get_node("../LevelController").call("trigger_mood_shift", to_warmer)
	)
