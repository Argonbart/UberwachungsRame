extends Node


var STARTSCREEN_SCENE_PATH = "res://scenes/startscreen.tscn"


func _ready() -> void:
	SceneSwitcher.switch_scene(STARTSCREEN_SCENE_PATH)
