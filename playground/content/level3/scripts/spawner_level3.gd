extends Node3D


@export var npc_spawn_location: Node3D
@export var npc_scene: PackedScene


func _ready():
	var limited_colors = [Globals.colors[0], Globals.colors[1], Globals.colors[2]]
	var humans_to_spawn = [randi_range(3,5), randi_range(3,5), randi_range(3,5)]
	for i in range(0, 2):
		var random_idx = randi_range(0,2)
		humans_to_spawn[random_idx] -= 1
		spawn_robot(limited_colors[random_idx])
	for color_idx in range(0, limited_colors.size()):
		print("color_idx: ", color_idx)
		for i in range(humans_to_spawn[color_idx]):
			spawn_human(limited_colors[color_idx])


func spawn_human(color: Color):
	var new_npc = npc_scene.instantiate()
	new_npc.npc_type = NPC.NPCType.HUMAN
	new_npc.position = Vector3(randf_range(-49.0, 49.0), 0.0, randf_range(-49.0, 49.0))
	npc_spawn_location.call_deferred("add_child", new_npc)
	new_npc.set_color(color)
	new_npc.set_color_path(color)


func spawn_robot(color: Color):
	var new_npc = npc_scene.instantiate()
	new_npc.npc_type = NPC.NPCType.ROBOT
	new_npc.position = Vector3(randf_range(-49.0, 49.0), 0.0, randf_range(-49.0, 49.0))
	npc_spawn_location.call_deferred("add_child", new_npc)
	new_npc.set_color(color)
	new_npc.set_color_path(color)
