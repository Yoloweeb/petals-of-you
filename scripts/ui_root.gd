extends CanvasLayer

const START_MENU_SCENE := "res://scenes/start_menu.tscn"

@onready var pause_menu: Control = $PauseMenu

var _is_open := false

var _prev_mouse_mode := Input.MOUSE_MODE_VISIBLE

func _ready() -> void:
	# UIRoot must keep processing during pause so it can unpause
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Wire pause menu signals
	pause_menu.resume_requested.connect(_on_resume_requested)
	pause_menu.restart_requested.connect(_on_restart_requested)
	pause_menu.main_menu_requested.connect(_on_main_menu_requested)
	pause_menu.quit_requested.connect(_on_quit_requested)

	_close_pause()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause"):
		# Avoid pausing inside Start Menu (and later other non-game scenes)
		if _is_in_start_menu():
			return
		if _is_open:
			_close_pause()
		else:
			_open_pause()
		get_viewport().set_input_as_handled()

func _open_pause() -> void:
	_is_open = true
	_prev_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	pause_menu.open()

func _close_pause() -> void:
	_is_open = false
	pause_menu.close()
	get_tree().paused = false
	Input.mouse_mode = _prev_mouse_mode

func _is_in_start_menu() -> bool:
	var current := get_tree().current_scene
	return current != null and current.scene_file_path == START_MENU_SCENE

func _on_resume_requested() -> void:
	_close_pause()

func _on_restart_requested() -> void:
	_close_pause()
	get_tree().reload_current_scene()

func _on_main_menu_requested() -> void:
	_close_pause()
	get_tree().change_scene_to_file(START_MENU_SCENE)

func _on_quit_requested() -> void:
	get_tree().quit()
