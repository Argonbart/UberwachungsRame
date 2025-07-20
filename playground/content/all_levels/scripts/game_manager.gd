extends Node


@export var ui: CanvasLayer
@export var npcs: Node3D

var robot_counter: int
var max_robot_count: int = 0


func _ready():
	
	# set robot vars
	await get_tree().process_frame
	for npc in npcs.get_children():
		if npc.npc_type == NPC.NPCType.ROBOT:
			max_robot_count += 1
	robot_counter = max_robot_count
	ui.get_child(0).get_child(0).get_child(1).text = str("Roboter ", robot_counter, "/", max_robot_count)
	
	# set guesses
	Globals.guesses = Globals.MAX_GUESSES
	ui.get_child(0).get_child(0).get_child(2).text = str("Guesses Left: ", Globals.guesses)
	
	# connect signals
	Globals.robot_found.connect(remove_robot)
	Globals.failed_guess.connect(decrease_guesses)


func remove_robot():
	robot_counter -= 1
	ui.get_child(0).get_child(0).get_child(1).text = str("Roboter ", robot_counter, "/", max_robot_count)
	if robot_counter == 0:
		show_won()


func decrease_guesses():
	Globals.guesses -= 1
	ui.get_child(0).get_child(0).get_child(2).text = str("Guesses Left: ", Globals.guesses)
	if Globals.guesses == 0:
		show_game_over()


func show_won():
	Globals.game_won.emit()
	ui.get_child(0).get_child(0).get_child(0).text = str("YOU WON!")


func show_game_over():
	Globals.game_lost.emit()
	ui.get_child(0).get_child(0).get_child(0).text = str("YOU LOST!")
