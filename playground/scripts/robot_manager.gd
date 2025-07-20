extends Node


@export var ui: CanvasLayer
@export var humans: Node3D

var robot_counter: int
var max_robot_count: int = 0


func _ready():
	
	# set robot vars
	for human: NPC in humans.get_children():
		if human.npc_type == NPC.NPCType.ROBOT:
			max_robot_count += 1
	robot_counter = max_robot_count
	ui.get_child(0).get_child(0).get_child(1).text = str("Roboter ", robot_counter, "/", max_robot_count)
	
	# connect signals
	Globals.robot_found.connect(remove_robot)


func remove_robot():
	robot_counter -= 1
	ui.get_child(0).get_child(0).get_child(1).text = str("Roboter ", robot_counter, "/", max_robot_count)
	if robot_counter == 0:
		show_won()


func show_won():
	Globals.game_won.emit()
	ui.get_child(0).get_child(0).get_child(0).text = str("YOU WON!")
