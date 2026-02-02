extends Area2D

signal collected

func _ready() -> void:
	body_entered.connect(_on_enter)

func _on_enter(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("set_carrying_water"):
			body.set_carrying_water(true)
		emit_signal("collected")
		queue_free()
