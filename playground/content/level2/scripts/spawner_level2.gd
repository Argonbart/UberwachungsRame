extends Node3D


@export var npc_spawn_location: Node3D
@export var npc_scene: PackedScene

var todos: Array[NPC.AreaType]


func _ready():
	
	# randomize todos
	for i in range(0, randi_range(4,6)):
		todos.append(NPC.AreaType.values()[randi_range(0,3)])
	
	# make all npcs different colors
	var limited_colors = [Globals.colors[0], Globals.colors[1], Globals.colors[2], Globals.colors[3]]
	var random_int = randi_range(0, 3)
	for color_idx in range(0, limited_colors.size()):
		if color_idx == random_int:
			spawn_robot(limited_colors[color_idx])
		else:
			spawn_human(limited_colors[color_idx])


func spawn_human(color: Color):
	var new_npc = npc_scene.instantiate()
	new_npc.npc_type = NPC.NPCType.HUMAN
	new_npc.position = Vector3(randf_range(-49.0, 49.0), 0.0, randf_range(-49.0, 49.0))
	npc_spawn_location.call_deferred("add_child", new_npc)
	new_npc.set_color(color)
	new_npc.set_color_path(todos)


func spawn_robot(color: Color):
	var new_npc = npc_scene.instantiate()
	new_npc.npc_type = NPC.NPCType.ROBOT
	new_npc.position = Vector3(randf_range(-49.0, 49.0), 0.0, randf_range(-49.0, 49.0))
	npc_spawn_location.call_deferred("add_child", new_npc)
	new_npc.set_color(color)
	new_npc.set_color_path(todos)
