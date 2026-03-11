extends Area2D

var player_in_range: bool = false
var is_opened: bool = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		if not is_opened:
			UiRoot.hud_set_hint("E: Open window")

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		if not is_opened:
			UiRoot.hud_clear_hint()

func _process(_delta: float) -> void:
	if player_in_range and not is_opened and Input.is_action_just_pressed("interact"):
		open_window()

func open_window() -> void:
	is_opened = true
	UiRoot.hud_clear_hint()

	# Optional: trigger visual change here
	UiRoot.hud_set_hint("The window opens. Sunlight shines through.")

	print("Rain window opened")

	await get_tree().create_timer(2.0).timeout
	UiRoot.hud_clear_hint()
