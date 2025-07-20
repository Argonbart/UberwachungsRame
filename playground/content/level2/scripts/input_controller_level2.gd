extends Node3D


const RAY_LENGTH = 1000
const LEVEL2_SCENE_PATH = "res://content/level2/level2.tscn"
const LEVEL3_SCENE_PATH = "res://content/general/scenes/winscreen.tscn"

@export var camera: Camera3D  # Assign this in the Inspector

var level2_finished: bool = false
var level2_lost: bool = false


func _ready():
	Globals.game_won.connect(active_level3_button)
	Globals.game_lost.connect(active_level2_repeat_button)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:  # Left click
		
		if level2_finished:
			# Load new scene
			var s = load(LEVEL3_SCENE_PATH)
			var won_scene = s.instantiate()
			
			# Add scene to tree
			get_tree().root.add_child(won_scene)
			get_tree().current_scene = won_scene
			return
		
		if level2_lost:
			SceneSwitcher.switch_scene(LEVEL2_SCENE_PATH)
			return
		
		var mouse_pos = event.position
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_dir = camera.project_ray_normal(mouse_pos)
		
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
		
		# Check if ray hits the XZ-plane (where y == 0)
		if ray_dir.y != 0.0:
			var t = -ray_origin.y / ray_dir.y
			if t > 0:
				pass


func active_level3_button():
	level2_finished = true


func active_level2_repeat_button():
	level2_lost = true
