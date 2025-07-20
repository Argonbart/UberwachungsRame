extends Button

var FIRST_SCENE_PATH = "res://content/level1/level1.tscn"

func _on_pressed() -> void:
	SceneSwitcher.switch_scene(FIRST_SCENE_PATH)
