extends Node


@export var scene_path_menu: PackedScene
@export var scene_path_level1: PackedScene
@export var scene_path_level2: PackedScene
@export var scene_path_level3: PackedScene
@export var scene_path_end: PackedScene

enum Scene {
	MENU,
	LEVEL1,
	LEVEL2,
	LEVEL3,
	END,
}

var scene_paths = {}

var current_scene = null


func _ready():
	scene_paths = {
		Scene.MENU: scene_path_menu.resource_path,
		Scene.LEVEL1: scene_path_level1.resource_path,
		Scene.LEVEL2: scene_path_level2.resource_path,
		Scene.LEVEL3: scene_path_level3.resource_path,
		Scene.END: scene_path_end.resource_path,
	}


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
