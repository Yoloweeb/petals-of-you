extends Node

@onready var overlay_layer: CanvasLayer = $"../OverlayLayer"
@onready var vignette: ColorRect = overlay_layer.get_node("OverlayRoot/VignetteOverlay") as ColorRect
@onready var ui: CanvasLayer = $"../UI" as CanvasLayer
@onready var choice_panel: Control = ui.get_node_or_null("ChoicePanel") as Control

@onready var puzzle: Node = $"../PuzzleController"
@onready var flower: Node = $"../Flower"   # Node2D with Flower.gd

var prompt: Label
var left_btn: Button
var right_btn: Button
var choice_cb: Callable = func(_b: bool): pass


func _ready() -> void:
	# --- Initial vignette state ---
	vignette.color = Color(0, 0, 0, 0.35)

	# --- Choice UI wiring (your existing logic) ---
	if choice_panel:
		prompt   = choice_panel.get_node("VBoxContainer/Prompt") as Label
		left_btn = choice_panel.get_node("VBoxContainer/HBoxContainer/Left") as Button
		right_btn= choice_panel.get_node("VBoxContainer/HBoxContainer/Right") as Button

		choice_panel.visible = false
		left_btn.pressed.connect(_on_left)
		right_btn.pressed.connect(_on_right)

	# --- Puzzle wiring (new) ---
	if puzzle:
		if puzzle.has_signal("fragment_collected"):
			puzzle.fragment_collected.connect(_on_fragment_collected)
		if puzzle.has_signal("puzzle_completed"):
			puzzle.puzzle_completed.connect(_on_puzzle_completed)
	else:
		push_warning("PuzzleController not found by LevelController.")

	# flower is optional, but if it's missing we just skip feedback
	if not flower:
		push_warning("Flower node not found by LevelController.")


# =========================
# Mood / vignette controls
# =========================

func trigger_mood_shift(to_warmer: bool = true, duration: float = 1.4) -> void:
	var tween = get_tree().create_tween()
	var target := Color(0.1, 0.05, 0.0, 0.15) if to_warmer else Color(0, 0, 0, 0.35)
	tween.tween_property(vignette, "color", target, duration)


# =========================
# Puzzle callbacks
# =========================

func _on_fragment_collected(count: int, total: int) -> void:
	# Small feedback every time you collect a fragment
	if flower and flower.has_method("pulse_subtle"):
		flower.pulse_subtle()


func _on_puzzle_completed() -> void:
	# Stronger feedback when puzzle is fully done
	trigger_mood_shift(true, 1.4)

	if flower and flower.has_method("bloom_big"):
		flower.bloom_big()

	# Short pause before moving on
	await get_tree().create_timer(1.2).timeout

	# Move to next chapter if Game singleton exists
	var game := get_tree().root.get_node_or_null("Game")
	if game and game.has_method("next_chapter"):
		game.next_chapter()
	else:
		push_warning("Game singleton or next_chapter() not found. Implement or adjust LevelController._on_puzzle_completed().")


# =========================
# Choice UI (unchanged)
# =========================

func show_choice(txt: String, ltxt: String, rtxt: String, cb: Callable) -> void:
	if not choice_panel or not prompt or not left_btn or not right_btn:
		return
	prompt.text = txt
	left_btn.text = ltxt
	right_btn.text = rtxt
	choice_cb = cb
	choice_panel.visible = true

func _on_left() -> void:
	choice_panel.visible = false
	choice_cb.call(true)

func _on_right() -> void:
	choice_panel.visible = false
	choice_cb.call(false)
