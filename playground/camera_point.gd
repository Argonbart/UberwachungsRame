extends Node3D  # CameraPoint

@export var orbit_speed_deg: float = 30.0  # degrees per second

func _process(delta):
	rotation.y += deg_to_rad(orbit_speed_deg * delta)
