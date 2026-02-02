extends Area2D

signal activated(star: Node2D)

var active := false
var enabled := false

func _ready() -> void:
	visible = false
	body_entered.connect(_on_enter)
	
func _on_enter(body: Node) -> void:
	if not enabled or active:
		return
	if body.is_in_group("player"):
		activate()
		
func activate() -> void:
	active = true
	modulate = Color(1, 1, 1, 1)
	scale = Vector2(1.15, 1.15)
	emit_signal("activated", self)
	
func enable() -> void:
	enabled = true
	visible = true
