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

	UiRoot.hud_set_hint("Sunlight pours in.")
	UiRoot.fade_to_light(1.5)

	await get_tree().create_timer(1.5).timeout
	UiRoot.hud_set_hint("The flower regains its strength.")

	await get_tree().create_timer(2.0).timeout
	UiRoot.reset_ui_state()
	get_tree().change_scene_to_file("res://scenes/levels/bloom.tscn")
