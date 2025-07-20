extends Node3D


const RAY_LENGTH = 1000
const LEVEL2_SCENE_PATH = "res://content/level2/level2.tscn"

@export var camera: Camera3D  # Assign this in the Inspector

var level1_finished: bool = false


func _ready():
	Globals.game_won.connect(active_level2_button)


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:  # Left click = click npc
		
		if level1_finished:
			SceneSwitcher.switch_scene(LEVEL2_SCENE_PATH)
			return
		
		var mouse_pos = event.position
		var ray_origin = camera.project_ray_origin(mouse_pos)
		
		var space_state = get_world_3d().direct_space_state
		var end = ray_origin + camera.project_ray_normal(mouse_pos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(ray_origin, end)
		query.collide_with_areas = true
		
		# ray searches for clickable areas (npcs)
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
	
	if event is InputEventMouseButton and event.pressed and event.button_index == 2:  # Right click = poop
		
		var mouse_pos = event.position
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_dir = camera.project_ray_normal(mouse_pos)
		
		# Check if ray hits the XZ-plane (where y == 0)
		if ray_dir.y != 0.0:
			var t = -ray_origin.y / ray_dir.y
			if t > 0:
				var hit_point = ray_origin + ray_dir * t
				Globals.poop_used.emit(hit_point)


func active_level2_button():
	level1_finished = true
