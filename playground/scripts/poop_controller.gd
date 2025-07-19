class_name PoopController
extends Node


@export var max_poop_count: int = 4
@export var ui: CanvasLayer

var poop_counter


func _ready():
	poop_counter = max_poop_count


func remove_poop():
	poop_counter -= 1
	ui.get_child(0).get_child(1).get_child(0).text = str("Kot ", poop_counter, "/4")
