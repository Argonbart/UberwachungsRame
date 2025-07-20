class_name PoopManager
extends Node


@export var max_poop_count: int = 4
@export var ui: CanvasLayer
@export var humans: Node3D
@export var poops: Node3D
@export var poop_scene: PackedScene

var poop_counter: int
var robot_counter: int
var max_robot_count: int = 0


func _ready():
	
	# set poop vars
	poop_counter = max_poop_count
	ui.get_child(0).get_child(1).get_child(0).text = str("Kot ", poop_counter, "/", max_poop_count)
	
	# set robot vars
	for human: NPC in humans.get_children():
		if human.npc_type == NPC.NPCType.ROBOT:
			max_robot_count += 1
	robot_counter = max_robot_count
	ui.get_child(0).get_child(0).get_child(1).text = str("Roboter ", robot_counter, "/", max_robot_count)
	
	# connect signals
	Globals.robot_found.connect(remove_robot)
	Globals.poop_used.connect(use_poop)


func remove_poop():
	poop_counter -= 1
	ui.get_child(0).get_child(1).get_child(0).text = str("Kot ", poop_counter, "/", max_poop_count)


func remove_robot():
	robot_counter -= 1
	ui.get_child(0).get_child(0).get_child(1).text = str("Roboter ", robot_counter, "/", max_robot_count)
	if robot_counter == 0:
		show_won()


func use_poop(hit_point):
	if poop_counter <= 0:
		return
	var new_poop = poop_scene.instantiate()
	new_poop.position = hit_point
	poops.call_deferred("add_child", new_poop)
	remove_poop()


func show_won():
	Globals.game_won.emit()
	ui.get_child(0).get_child(0).get_child(0).text = str("YOU WON!")
