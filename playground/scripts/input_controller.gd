extends Node3D


const RAY_LENGTH = 1000

@export var camera: Camera3D  # Assign this in the Inspector
@export var poops: Node3D
@export var poop_controller: PoopController
@export var poop_scene: PackedScene


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:  # Left click
		var mouse_pos = event.position
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_dir = camera.project_ray_normal(mouse_pos)
		
		var space_state = get_world_3d().direct_space_state
		var end = ray_origin + camera.project_ray_normal(mouse_pos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(ray_origin, end)
		query.collide_with_areas = true
		
		var result = space_state.intersect_ray(query)
		var excluded = []
		while result:
			var clicked_item = result["collider"]
			if clicked_item.get_groups().has("clickable"):
				clicked_item.get_parent().clicked()
				break
			excluded.append(clicked_item.get_rid())
			query.exclude = excluded
			result = space_state.intersect_ray(query)
		
		# Check if ray hits the XZ-plane (where y == 0)
		if ray_dir.y != 0.0:
			var t = -ray_origin.y / ray_dir.y
			if t > 0:
				if poop_controller.poop_counter <= 0:
					return
				var hit_point = ray_origin + ray_dir * t
				var new_poop = poop_scene.instantiate()
				new_poop.position = hit_point
				poops.call_deferred("add_child", new_poop)
				poop_controller.remove_poop()
