extends Node


enum Scene {
	MENU,
	LEVEL1,
	LEVEL2,
	END,
}

var scene_paths = {
	Scene.MENU: "res://content/on_start/scenes/startscreen.tscn",
	Scene.LEVEL1: "res://content/level1/level1.tscn",
	Scene.LEVEL2: "res://content/level2/level2.tscn",
	Scene.END: "res://content/general/scenes/winscreen.tscn",
}

var current_scene = null


func switch_scene(scene: Scene):
	call_deferred("_deferred_switch_scene", scene_paths[scene])


func _deferred_switch_scene(res_path):
	
	# Free previous scene
	if current_scene != null:
		current_scene.free()
	
	# Load new scene
	var s = load(res_path)
	current_scene = s.instantiate()
	
	# Add scene to tree
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
