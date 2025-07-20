class_name NPC
extends CharacterBody3D


# enums
enum NPCType {
	HUMAN,
	ROBOT,
}


# exports
@export var npc_type: NPCType
@export_category("Human Stats")
@export var human_speed: float = 4.0
@export var human_max_force: float = 0.4
@export var human_timer_refresh_rate: float = 0.5
@export var human_wander_ring_distance: float = 5.0
@export var human_wander_ring_radius: float = 2.0
@export_category("Robot Stats")
@export var robot_speed: float = 4.0
@export var robot_max_force: float = 0.4
@export var robot_timer_refresh_rate: float = 0.5
@export var robot_wander_ring_distance: float = 5.0
@export var robot_wander_ring_radius: float = 2.0
@export_category("Other Stats")
@export var colors: Array[Color]


# variables
var npc_speed: float = 4.0
var npc_max_force: float = 0.4
var npc_timer_refresh_rate: float = 0.5
var npc_wander_ring_distance: float = 5.0
var npc_wander_ring_radius: float = 2.0
var acceleration: Vector3 = Vector3.ZERO
var target_position: Vector3
var timer: Timer
var running_from_poop: bool = false
var current_poop
var game_finished: bool = false


func _ready():
	
	# set variables based on npc type
	match npc_type:
		NPCType.HUMAN:
			npc_speed = human_speed
			npc_max_force = human_max_force
			npc_timer_refresh_rate = human_timer_refresh_rate
			npc_wander_ring_distance = human_wander_ring_distance
			npc_wander_ring_radius = human_wander_ring_radius
		NPCType.ROBOT:
			npc_speed = robot_speed
			npc_max_force = robot_max_force
			npc_timer_refresh_rate = robot_timer_refresh_rate
			npc_wander_ring_distance = robot_wander_ring_distance
			npc_wander_ring_radius = robot_wander_ring_radius
	
	# create refresh timer
	timer = Timer.new()
	timer.wait_time = npc_timer_refresh_rate
	timer.autostart = true
	timer.timeout.connect(refresh_direction)
	self.add_child(timer)
	
	# set initial values
	refresh_direction()
	velocity = Vector3.FORWARD.rotated(Vector3.UP, randf_range(0, TAU)) * npc_speed
	
	# set random color
	set_color(colors[randi_range(0, colors.size()-1)])
	
	# connect signals
	Globals.game_won.connect(stop_movement)
	Globals.game_lost.connect(stop_movement)


func _physics_process(delta):
	
	# pause effect when won
	if game_finished:
		find_child("NPCModel").get_child(1).stop()
		return
	
	# check wander type
	if npc_type == NPCType.ROBOT:
		acceleration = wander_robot()
	else:
		acceleration = wander_human()
	
	# set velocity
	velocity += acceleration
	if velocity.length() > npc_speed:
		velocity = velocity.normalized() * npc_speed
	
	if running_from_poop:
		var run_direction = global_transform.origin - current_poop.global_transform.origin
		run_direction.y = 0.0
		velocity = run_direction.normalized() * npc_speed * 2.0
	
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


# function for robot movement
func wander_robot() -> Vector3:
	var target_distance = target_position - global_transform.origin
	target_distance.y = 0
	if target_distance.length() < 1.0:
		refresh_direction()
		timer.start()
		return Vector3.ZERO
	return seek(target_position)


# function for human movement
func wander_human() -> Vector3:
	var future = global_transform.origin + velocity.normalized() * npc_wander_ring_distance
	var offset = Vector3(npc_wander_ring_radius, 0, 0).rotated(Vector3.UP, randf_range(0, TAU))
	var target = future + offset
	return seek(target)


func refresh_direction():
	var new_target = get_random_nav_point()
	while (new_target - global_transform.origin).length() < 20.0:
		new_target = get_random_nav_point()
	new_target.y = 0.0
	target_position = new_target


func get_random_nav_point() -> Vector3:
	var x = randf_range(-50, 50)
	var z = randf_range(-50, 50)
	return Vector3(x, 0, z)


func entered_poop(poop):
	if npc_type == NPCType.ROBOT:
		return
	running_from_poop = true
	current_poop = poop


func exited_poop(_poop):
	if npc_type == NPCType.ROBOT:
		return
	running_from_poop = false


func set_color(color: Color):
	var color_material = StandardMaterial3D.new()
	color_material.albedo_color = color
	find_child("NPCModel").get_child(0).get_child(0).get_child(0).material_override = color_material
	find_child("NPCModel").get_child(0).get_child(0).get_child(1).material_override = color_material
	find_child("NPCModel").get_child(0).get_child(0).get_child(2).material_override = color_material
	find_child("NPCModel").get_child(0).get_child(0).get_child(3).material_override = color_material
	find_child("NPCModel").get_child(0).get_child(0).get_child(4).material_override = color_material
	find_child("NPCModel").get_child(0).get_child(0).get_child(5).material_override = color_material


func clicked():
	if npc_type == NPCType.ROBOT:
		Globals.robot_found.emit()
		queue_free()
	else:
		Globals.failed_guess.emit()
		npc_speed *= 3.0
		await get_tree().create_timer(1.0).timeout
		npc_speed /= 3.0


func stop_movement():
	game_finished = true
