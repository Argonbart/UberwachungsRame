extends CharacterBody3D


# enums
enum NPCType {
	HUMAN,
	ROBOT,
}

enum AreaType {
	YELLOW,
	GREEN,
	PINK,
	BLUE,
}


# exports
@export var npc_type: NPCType
@export_category("NPC Stats")
@export var npc_speed: float = 20.0
@export var npc_max_force: float = 10.0
@export var npc_timer_refresh_rate: float = 0.5
@export var npc_wander_ring_distance: float = 5.0
@export var npc_wander_ring_radius: float = 2.0
@export_category("NPC Paths")
@export var todos_color_1: Array[AreaType]
@export var todos_color_2: Array[AreaType]
@export var todos_color_3: Array[AreaType]
@export var todos_color_4: Array[AreaType]
@export var todos_color_5: Array[AreaType]


# variables
var target_position: Vector3
var timer: Timer
var game_finished: bool = false
var todos: Array[AreaType]
var next_target_idx: int = 0


func _ready():
	
	# randomize colors
	Globals.shuffle_colors()
	
	# randomize npc speed
	npc_speed = npc_speed * randf_range(0.5, 2.0)
	
	# create refresh timer
	timer = Timer.new()
	timer.wait_time = npc_timer_refresh_rate
	timer.autostart = true
	timer.timeout.connect(refresh_direction)
	self.add_child(timer)
	
	# set random color
	var random_color = Globals.colors[randi_range(0, Globals.colors.size()-1)]
	set_color(random_color)
	
	# set initial values
	set_color_path(random_color)
	velocity = Vector3.FORWARD.rotated(Vector3.UP, randf_range(0, TAU)) * npc_speed
	
	# connect signals
	Globals.game_won.connect(stop_movement)
	Globals.game_lost.connect(stop_movement)


func _physics_process(delta):
	
	# pause effect when won
	if game_finished:
		find_child("NPCModel").get_child(1).stop()
		return
	
	# set velocity
	velocity += wander()
	if velocity.length() > npc_speed:
		velocity = velocity.normalized() * npc_speed
	
	# move unit
	move_and_slide()
	
	# rotate unit to moving direction
	if velocity.length() > 0.1:
		var move_dir = velocity.normalized()
		move_dir.y = 0
		var current_rotation = rotation.y
		var target_rotation = atan2(-move_dir.x, -move_dir.z)  # Godot faces -Z
		rotation.y = lerp_angle(current_rotation, target_rotation, delta * 8.0)
	
	# wrapping
	var pos = global_transform.origin
	if pos.x > 50: pos.x = -50
	if pos.x < -50: pos.x = 50
	if pos.z > 50: pos.z = -50
	if pos.z < -50: pos.z = 50
	global_transform.origin = pos


# function for movement
func seek(target: Vector3) -> Vector3:
	var desired = target - global_transform.origin
	desired.y = 0
	desired = desired.normalized() * npc_speed
	var steer = desired - velocity
	if steer.length() > npc_max_force:
		steer = steer.normalized() * npc_max_force
	return steer


# function for movement
func wander() -> Vector3:
	var target_distance = target_position - global_transform.origin
	target_distance.y = 0
	if target_distance.length() < 1.0:
		refresh_direction()
		timer.start()
		return Vector3.ZERO
	return seek(target_position)


# function to get next color target
func refresh_direction():
	if (target_position - global_transform.origin).length() < 10.0:
		target_position = get_next_color_point(todos[next_target_idx])
		next_target_idx = posmod((next_target_idx + 1), todos.size())


# get position of next color
func get_next_color_point(color: AreaType) -> Vector3:
	match color:
		AreaType.YELLOW:
			return Vector3(-30.0, 0.0, -30.0)
		AreaType.GREEN:
			return Vector3(30.0, 0.0, -30.0)
		AreaType.PINK:
			return Vector3(30.0, 0.0, 30.0)
		AreaType.BLUE:
			return Vector3(-30.0, 0.0, 30.0)
	return Vector3.ZERO


# set color of the npc
func set_color(color: Color):
	var color_material = StandardMaterial3D.new()
	color_material.albedo_color = color
	find_child("NPCModel").get_child(0).get_child(0).get_child(0).material_override = color_material
	find_child("NPCModel").get_child(0).get_child(0).get_child(1).material_override = color_material
	find_child("NPCModel").get_child(0).get_child(0).get_child(2).material_override = color_material
	find_child("NPCModel").get_child(0).get_child(0).get_child(3).material_override = color_material
	find_child("NPCModel").get_child(0).get_child(0).get_child(4).material_override = color_material
	find_child("NPCModel").get_child(0).get_child(0).get_child(5).material_override = color_material


# set todos for the npc
func set_color_path(color: Color):
	
	# set random todos if robot
	if npc_type == NPCType.ROBOT:
		var todos_color_random: Array[AreaType] = []
		for i in range(10):
			todos_color_random.append(randi_range(0, AreaType.size()-1))
		target_position = get_next_color_point(todos_color_random[next_target_idx])
		todos = todos_color_random
		next_target_idx = posmod((next_target_idx + 1), todos.size())
		return
	
	# set todos based on color for humans
	if color == Globals.colors[0]:
		next_target_idx = randi_range(0, todos_color_1.size()-1)
		target_position = get_next_color_point(todos_color_1[next_target_idx])
		todos = todos_color_1
	if color == Globals.colors[1]:
		next_target_idx = randi_range(0, todos_color_2.size()-1)
		target_position = get_next_color_point(todos_color_2[next_target_idx])
		todos = todos_color_2
	if color == Globals.colors[2]:
		next_target_idx = randi_range(0, todos_color_3.size()-1)
		target_position = get_next_color_point(todos_color_3[next_target_idx])
		todos = todos_color_3
	if color == Globals.colors[3]:
		next_target_idx = randi_range(0, todos_color_4.size()-1)
		target_position = get_next_color_point(todos_color_4[next_target_idx])
		todos = todos_color_4
	if color == Globals.colors[4]:
		next_target_idx = randi_range(0, todos_color_5.size()-1)
		target_position = get_next_color_point(todos_color_5[next_target_idx])
		todos = todos_color_5
	next_target_idx = posmod((next_target_idx + 1), todos.size())


# npc clicked
func clicked():
	if npc_type == NPCType.ROBOT:
		Globals.robot_found.emit()
		queue_free()
	else:
		Globals.failed_guess.emit()
		npc_speed *= 3.0
		await get_tree().create_timer(1.0).timeout
		npc_speed /= 3.0


# game won or lost
func stop_movement():
	game_finished = true
