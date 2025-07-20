extends CharacterBody3D


# exports
@export_category("Human Stats")
@export var billy_speed: float = 15.0
@export var billy_max_force: float = 10.0
@export var billy_timer_refresh_rate: float = 0.5
@export var billy_wander_ring_distance: float = 5.0
@export var billy_wander_ring_radius: float = 2.0


# variables
var acceleration: Vector3 = Vector3.ZERO
var target_position: Vector3
var timer: Timer
var running_from_poop: bool = false
var current_poop
var game_finished: bool = false


func _ready():
	
	# create refresh timer
	timer = Timer.new()
	timer.wait_time = billy_timer_refresh_rate
	timer.autostart = true
	timer.timeout.connect(refresh_direction)
	self.add_child(timer)
	
	# set initial values
	refresh_direction()
	velocity = Vector3.FORWARD.rotated(Vector3.UP, randf_range(0, TAU)) * billy_speed
	
	# set random color
	set_color(Color("ff8700"))
	
	# connect signals
	Globals.game_won.connect(stop_movement)
	Globals.game_lost.connect(stop_movement)


func _physics_process(delta):
	
	# pause effect when won
	if game_finished:
		find_child("NPCModel").get_child(2).stop()
		return
	
	# set velocity
	velocity += wander_billy()
	if velocity.length() > billy_speed:
		velocity = velocity.normalized() * billy_speed
	
	# poop run
	if running_from_poop:
		var run_direction = global_transform.origin - current_poop.global_transform.origin
		run_direction.y = 0.0
		velocity = run_direction.normalized() * billy_speed * 2.0
	
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
	desired = desired.normalized() * billy_speed
	var steer = desired - velocity
	if steer.length() > billy_max_force:
		steer = steer.normalized() * billy_max_force
	return steer


# function for billy movement
func wander_billy() -> Vector3:
	var future = global_transform.origin + velocity.normalized() * billy_wander_ring_distance
	var offset = Vector3(billy_wander_ring_radius, 0, 0).rotated(Vector3.UP, randf_range(0, TAU / 1.2))
	var target = future + offset
	return seek(target)


# change robot direction
func refresh_direction():
	var new_target = get_random_nav_point()
	while (new_target - global_transform.origin).length() < 20.0:
		new_target = get_random_nav_point()
	new_target.y = 0.0
	target_position = new_target


# new point for robot
func get_random_nav_point() -> Vector3:
	var x = randf_range(-50, 50)
	var z = randf_range(-50, 50)
	return Vector3(x, 0, z)


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


# when npc gets clicked by the player
func clicked():
	pass


# game ends by winning or losing
func stop_movement():
	game_finished = true
