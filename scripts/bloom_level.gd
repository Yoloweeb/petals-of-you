extends Node2D

const START_MENU_SCENE := "res://scenes/start_menu.tscn"

@onready var sunlight_overlay: ColorRect = $SunlightOverlay
@onready var flower_sprite: Sprite2D = $Flower

func _ready() -> void:
	if has_node("Player"):
		$Player.global_position = $PlayerSpawn.global_position

	UiRoot.reset_ui_state()
	Global.has_bloom_jump = true
	UiRoot.hud_set_hint("The flower regains its strength.")

	sunlight_overlay.modulate.a = 0.0
	flower_sprite.modulate = Color(0.7, 0.7, 0.7, 1.0)

	var tween := create_tween()
	tween.tween_property(sunlight_overlay, "modulate:a", 0.75, 1.8)
	tween.parallel().tween_property(flower_sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.8)

	await get_tree().create_timer(3.5).timeout
	UiRoot.hud_set_hint("The garden blooms again.")
	Global.game_completed = true

	await get_tree().create_timer(2.5).timeout
	UiRoot.reset_ui_state()
	get_tree().change_scene_to_file(START_MENU_SCENE)
