extends Node


# variables
var current_scene = null


func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)


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
