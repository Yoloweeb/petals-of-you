extends Control

signal resume_requested
signal restart_requested
signal main_menu_requested
signal quit_requested

@onready var resume_button: Button = $CenterContainer/PanelContainer/VBoxContainer/ResumeButton

func _ready() -> void:
	# Critical: pause menu must work while the tree is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func open() -> void:
	visible = true
	resume_button.grab_focus()

func close() -> void:
	visible = false


func _on_resume_button_pressed() -> void:
	resume_requested.emit()

func _on_restart_button_pressed() -> void:
	restart_requested.emit()

func _on_main_menu_button_pressed() -> void:
	main_menu_requested.emit()

func _on_quit_button_pressed() -> void:
	quit_requested.emit()


func _on_resume_button_mouse_entered() -> void:
	print("hover resume")
