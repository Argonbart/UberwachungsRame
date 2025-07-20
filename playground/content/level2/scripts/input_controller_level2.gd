extends Node3D


@export var camera: Camera3D  # Assign this in the Inspector
@export var ui: CanvasLayer

var level2_finished: bool = false
var level2_lost: bool = false


func _ready():
	ui.get_child(0).get_child(1).get_child(0).visible = false # hide kot ui
	Globals.game_won.connect(active_level3_button)
	Globals.game_lost.connect(active_level2_repeat_button)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:  # Left click
		
		# overlay win scene (text)
		if level2_finished:
			var s = load(SceneSwitcher.scene_paths[SceneSwitcher.Scene.END])
			var won_scene = s.instantiate()
			get_tree().root.add_child(won_scene)
			get_tree().current_scene = won_scene
			return
		
		# failed level
		if level2_lost:
			SceneSwitcher.switch_scene(SceneSwitcher.Scene.LEVEL2)
			return
		
		# click npc
		var mouse_pos = event.position
		var ray_origin = camera.project_ray_origin(mouse_pos)
		
		var space_state = get_world_3d().direct_space_state
		var end = ray_origin + camera.project_ray_normal(mouse_pos) * 1000 # RAY_LENGTH
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


func active_level3_button():
	level2_finished = true


func active_level2_repeat_button():
	level2_lost = true
