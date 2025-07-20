extends Node


var MAX_GUESSES: int = 5

# signals
signal robot_found()
signal poop_used(hit_point)
signal failed_guess()
signal game_won()
signal game_lost()


var guesses


func _ready():
	robot_found.get_name()
	poop_used.get_name()
	failed_guess.get_name()
	game_won.get_name()
	game_lost.get_name()
