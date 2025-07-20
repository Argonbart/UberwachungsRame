extends Node


# signals
signal robot_found()
signal poop_used(hit_point)
signal game_won()


func _ready():
	robot_found.get_name()
	poop_used.get_name()
	game_won.get_name()
