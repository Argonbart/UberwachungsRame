extends Node


@export var max_poop_count: int = 4
@export var ui: CanvasLayer
@export var poops: Node3D
@export var poop_scene: PackedScene

var poop_counter: int


func _ready():
	
	# set poop vars
	poop_counter = max_poop_count
	ui.get_child(0).get_child(1).get_child(0).text = str("Kot ", poop_counter, "/", max_poop_count)
	
	# connect signals
	Globals.poop_used.connect(use_poop)


func remove_poop():
	poop_counter -= 1
	ui.get_child(0).get_child(1).get_child(0).text = str("Kot ", poop_counter, "/", max_poop_count)


func use_poop(hit_point):
	if poop_counter <= 0:
		return
	var new_poop = poop_scene.instantiate()
	new_poop.position = hit_point
	poops.call_deferred("add_child", new_poop)
	remove_poop()
