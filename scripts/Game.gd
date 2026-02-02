extends Node

var flags: Dictionary = {}              # e.g., {"chose_compassion": true}
var chapter: String = "WITHER"          # WITHER -> RAIN -> BLOOM

func set_flag(flag_name: String, value: bool = true) -> void:
	flags[flag_name] = value

func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)

func next_chapter() -> void:
	match chapter:
		"WITHER": chapter = "RAIN"
		"RAIN": chapter = "BLOOM"
		"BLOOM": chapter = "END"
	_load_chapter()

func _load_chapter() -> void:
	var scene_path: String = ""
	match chapter:
		"WITHER":
			scene_path = "res://scenes/levels/wither.tscn"
		"RAIN":
			scene_path = "res://scenes/levels/rain.tscn"
		"BLOOM":
			scene_path = "res://scenes/levels/bloom.tscn"
		"END":
			scene_path = "res://scenes/levels/ending.tscn"
		_:
			scene_path = "res://scenes/levels/wither.tscn"

	# Safety: warn if the file is missing
	if not ResourceLoader.exists(scene_path):
		push_error("Scene not found: %s" % scene_path)
		return

	get_tree().change_scene_to_file(scene_path)

func save_game() -> void:
	var data = {"flags": flags, "chapter": chapter}
	var f = FileAccess.open("user://save.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(data))
	f.close()

func load_game() -> void:
	if not FileAccess.file_exists("user://save.json"): return
	var f = FileAccess.open("user://save.json", FileAccess.READ)
	var data = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(data) == TYPE_DICTIONARY:
		flags = data.get("flags", {})
		chapter = data.get("chapter", "WITHER")
