extends Node3D


@export var human_amount: int = 0
@export var robot_amount: int = 0
@export var npc_spawn_location: Node3D
@export var npc_scene: PackedScene


func _ready():
	
	for i in range(human_amount):
		spawn_human()
	
	for i in range(robot_amount):
		spawn_robot()


func spawn_human():
	var new_npc = npc_scene.instantiate()
	new_npc.npc_type = NPC.NPCType.HUMAN
	new_npc.position = Vector3(randf_range(-49.0, 49.0), 0.0, randf_range(-49.0, 49.0))
	npc_spawn_location.call_deferred("add_child", new_npc)


func spawn_robot():
	var new_npc = npc_scene.instantiate()
	new_npc.npc_type = NPC.NPCType.ROBOT
	new_npc.position = Vector3(randf_range(-49.0, 49.0), 0.0, randf_range(-49.0, 49.0))
	npc_spawn_location.call_deferred("add_child", new_npc)
