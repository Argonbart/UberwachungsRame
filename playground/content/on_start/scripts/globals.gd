extends Node


var MAX_GUESSES: int = 5

# signals
signal robot_found()
signal poop_used(hit_point)
signal failed_guess()
signal game_won()
signal game_lost()


var guesses
var colors


func _ready():
	shuffle_colors()
	robot_found.get_name()
	poop_used.get_name()
	failed_guess.get_name()
	game_won.get_name()
	game_lost.get_name()


func shuffle_colors():
	var new_color_list = [Color("ff0000"), Color("00ff00"), Color("0000ff"), Color("ff00ff"), Color("ffff00")]
	new_color_list.shuffle()
	colors = new_color_list
