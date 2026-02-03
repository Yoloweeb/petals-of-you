extends Node2D

@onready var stars: Array[Node2D] = []
@onready var line: Line2D = $ConstellationLine
@onready var blocker: Node = $Blocker
@onready var water: Area2D = $WaterDrop

var current_index := 0

func _ready() -> void:
	line.visible = false

	# Connect stars
	for child in $Stars.get_children():
		var star := child as Node2D
		if star:
			stars.append(star)
	for s in stars:
		s.activated.connect(_on_star_activated)

	# Enable only first star
	stars[0].enable()

	# Water hidden until constellation complete
	water.visible = false

func _on_star_activated(star: Node2D) -> void:
	if stars[current_index] != star:
		return

	current_index += 1
	_update_constellation()

	if current_index < stars.size():
		stars[current_index].enable()
	else:
		_complete_constellation()

func _update_constellation() -> void:
	line.clear_points()
	for i in range(current_index):
		line.add_point(stars[i].global_position)
	line.visible = current_index >= 2

func _complete_constellation() -> void:
	line.add_point(stars[0].global_position) # close triangle
	line.visible = true

	# Open path
	blocker.queue_free()
	water.visible = true
