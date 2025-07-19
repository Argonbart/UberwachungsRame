extends Node3D


func _on_poop_area_body_entered(body: CharacterBody3D):
	if body.get_groups().has("human") or body.get_groups().has("robot"):
		body.entered_poop(self)


func _on_poop_area_body_exited(body):
	if body.get_groups().has("human") or body.get_groups().has("robot"):
		body.exited_poop(self)
