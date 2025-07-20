extends Node


@export var scene_path_menu: PackedScene
@export var scene_path_level1: PackedScene
@export var scene_path_level2: PackedScene
@export var scene_path_level3: PackedScene
@export var scene_path_level4: PackedScene
@export var scene_path_win: PackedScene
@export var scene_path_lose: PackedScene

enum Scene {
	MENU,
	LEVEL1,
	LEVEL2,
	LEVEL3,
	LEVEL4,
	WIN,
	LOSE,
}

var scene_paths = {}

var current_scene = null
var scenes_to_delete = []


func _ready():
	scene_paths = {
		Scene.MENU: scene_path_menu.resource_path,
		Scene.LEVEL1: scene_path_level1.resource_path,
		Scene.LEVEL2: scene_path_level2.resource_path,
		Scene.LEVEL3: scene_path_level3.resource_path,
		Scene.LEVEL4: scene_path_level4.resource_path,
		Scene.WIN: scene_path_win.resource_path,
		Scene.LOSE: scene_path_lose.resource_path,
	}


func add_scene(scene: Scene):
	call_deferred("_deferred_switch_scene_2", scene_paths[scene])


func switch_scene(scene: Scene):
	call_deferred("_deferred_switch_scene", scene_paths[scene])


func _deferred_switch_scene(res_path):
	
	# Free previous scene
	if current_scene != null:
		for scene in scenes_to_delete:
			if scene:
				scene.free()
	
	# Load new scene
	var s = load(res_path)
	current_scene = s.instantiate()
	
	# Add scene to tree
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
	# Add scene to free later
	if current_scene != null:
		scenes_to_delete.append(current_scene)


func _deferred_switch_scene_2(res_path):
	# Load new scene
	var s = load(res_path)
	current_scene = s.instantiate()
	
	# Add scene to tree
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
	# Add scene to free later
	if current_scene != null:
		scenes_to_delete.append(current_scene)
