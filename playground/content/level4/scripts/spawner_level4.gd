extends Node3D


@export var human_amount: int = 0
@export var robot_amount: int = 0
@export var billy_amount: int = 0
@export var npc_spawn_location: Node3D
@export var npc_scene: PackedScene
@export var billy_scene: PackedScene

var house_colors


func _ready():
	
	house_colors = [Color(1.0, 1.0, 0.0, 1.0), Color(0.0, 1.0, 0.0, 1.0), Color(1.0, 0.0, 1.0, 1.0), Color(0.0, 1.0, 1.0, 1.0)]
	
	for i in range(human_amount):
		spawn_human(house_colors[randi_range(0,3)])
	
	for i in range(robot_amount):
		spawn_robot(house_colors[randi_range(0,3)])
	
	for i in range(billy_amount):
		spawn_billy()


func spawn_human(color: Color):
	var new_npc = npc_scene.instantiate()
	new_npc.npc_type = NPC.NPCType.HUMAN
	new_npc.position = Vector3(randf_range(-49.0, 49.0), 0.0, randf_range(-49.0, 49.0))
	npc_spawn_location.call_deferred("add_child", new_npc)
	new_npc.set_color(color)
	
	if color == house_colors[0]:
		new_npc.home_position = Vector3(-30.0, 0.0, -30.0)
	if color == house_colors[1]:
		new_npc.home_position = Vector3(30.0, 0.0, -30.0)
	if color == house_colors[2]:
		new_npc.home_position = Vector3(30.0, 0.0, 30.0)
	if color == house_colors[3]:
		new_npc.home_position = Vector3(-30.0, 0.0, 30.0)


func spawn_robot(color: Color):
	var new_npc = npc_scene.instantiate()
	new_npc.npc_type = NPC.NPCType.ROBOT
	new_npc.position = Vector3(randf_range(-49.0, 49.0), 0.0, randf_range(-49.0, 49.0))
	npc_spawn_location.call_deferred("add_child", new_npc)
	new_npc.set_color(color)


func spawn_billy():
	var new_npc = billy_scene.instantiate()
	new_npc.position = Vector3(randf_range(-49.0, 49.0), 0.0, randf_range(-49.0, 49.0))
	npc_spawn_location.call_deferred("add_child", new_npc)
