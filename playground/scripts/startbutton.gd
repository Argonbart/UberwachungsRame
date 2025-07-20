extends Button

var FIRST_SCENE_PATH = "res://scenes/levels/level1.tscn"

func _on_pressed() -> void:
	SceneSwitcher.switch_scene(FIRST_SCENE_PATH)
