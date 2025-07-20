extends Node3D


@export var orbit_speed_deg: float = 30.0


func _process(delta):
	rotation.y += deg_to_rad(orbit_speed_deg * delta)
