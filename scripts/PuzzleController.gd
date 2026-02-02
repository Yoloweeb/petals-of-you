extends Node2D

signal fragment_collected(count: int, total: int)
signal puzzle_completed

@export var enforce_sequence: bool = true

var _next_index: int = 0
var _total: int = 0
var _collected: int = 0

@onready var fragments_root: Node = $Fragments

func _ready() -> void:
	# Register all fragment children
	var frags := fragments_root.get_children()
	_total = frags.size()
	for f in frags:
		if f.has_method("register_to_controller"):
			f.register_to_controller(self)
		else:
			push_warning("%s has no register_to_controller()" % f.name)

func try_collect(order_index: int) -> bool:
	# Called by Fragment.gd when the player touches it.
	if enforce_sequence and order_index != _next_index:
		return false

	_next_index += 1
	_collected += 1

	emit_signal("fragment_collected", _collected, _total)

	if _collected >= _total:
		emit_signal("puzzle_completed")

	return true
