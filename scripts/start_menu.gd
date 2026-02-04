extends Control

const WITHER_SCENE := "res://scenes/levels/wither.tscn"

@onready var start_button: Button = $CenterContainer/PanelContainer/VBoxContainer/TitleImage/Start
@onready var quit_button: Button = $CenterContainer/PanelContainer/VBoxContainer/TitleImage/Quit

func _ready() -> void:
	start_button.grab_focus()
	

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(WITHER_SCENE)


func _on_quit_pressed() -> void:
	get_tree().quit()
