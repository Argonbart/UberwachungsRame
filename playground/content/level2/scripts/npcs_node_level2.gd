extends Node3D


var todos: Array[NPC.AreaType]


func _ready():
	# randomize todos
	for i in range(0, randi_range(4,6)):
		todos.append(NPC.AreaType.values()[randi_range(0,3)])
