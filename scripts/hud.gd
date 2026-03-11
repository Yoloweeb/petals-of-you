extends Control

@onready var hint_label: Label = $HintLabel

func _ready() -> void:
	clear_hint()

func set_hint(text: String) -> void:
	hint_label.text = text
	hint_label.visible = text.strip_edges().length() > 0

func clear_hint() -> void:
	hint_label.text = ""
	hint_label.visible = false
