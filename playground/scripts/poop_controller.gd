class_name PoopController
extends Node


@export var max_poop_count: int = 4
@export var ui: CanvasLayer
@export var humans: Node3D

var poop_counter: int
var robot_counter: int
var max_robot_count: int = 0


func _ready():
	
	# set poop vars
	poop_counter = max_poop_count
	ui.get_child(0).get_child(1).get_child(0).text = str("Kot ", poop_counter, "/", max_poop_count)
	
	# set robot vars
	for human: Human in humans.get_children():
		if human.wander_type == Human.WanderType.ROBOT:
			max_robot_count += 1
	robot_counter = max_robot_count
	ui.get_child(0).get_child(0).get_child(1).text = str("Roboter ", robot_counter, "/", max_robot_count)
	
	# connect signals
	Globals.robot_found.connect(remove_robot)


func remove_poop():
	poop_counter -= 1
	ui.get_child(0).get_child(1).get_child(0).text = str("Kot ", poop_counter, "/", max_poop_count)


func remove_robot():
	robot_counter -= 1
	ui.get_child(0).get_child(0).get_child(1).text = str("Roboter ", robot_counter, "/", max_robot_count)
	if robot_counter == 0:
		show_won()


func show_won():
	ui.get_child(0).get_child(0).get_child(0).text = str("YOU WON!")
