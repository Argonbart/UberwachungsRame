extends CharacterBody3D


# enums
enum WanderType {
	HUMAN,
	ROBOT,
}


# exports
@export var debug_on: bool = false
@export var wander_type: WanderType
@export var mob_speed: float = 4.0
@export var max_force: float = 0.4
@export var timer_refresh_rate: float = 0.5  # seconds
@export var wander_ring_distance: float = 5.0
@export var wander_ring_radius: float = 2.0
@export var colors: Array[Color]


# variables
var acceleration: Vector3 = Vector3.ZERO
var target_position: Vector3
var displacement: Vector3 = Vector3.ZERO
var timer: Timer
var running_from_poop: bool = false
var current_poop


func _ready():
	
	# create refresh timer
	timer = Timer.new()
	timer.wait_time = timer_refresh_rate
	timer.autostart = true
	timer.timeout.connect(refresh_direction)
	self.add_child(timer)
	
	# set initial values
	refresh_direction()
	velocity = Vector3.FORWARD.rotated(Vector3.UP, randf_range(0, TAU)) * mob_speed
	
	# set random color
	set_color(colors[randi_range(0, colors.size()-1)])


func _physics_process(delta):
	
	# check wander type
	if wander_type == WanderType.ROBOT:
		acceleration = wander_robot()
	else:
		acceleration = wander_human()
	
	# set velocity
	velocity += acceleration
	if velocity.length() > mob_speed:
		velocity = velocity.normalized() * mob_speed
	
	if running_from_poop:
		var run_direction = global_transform.origin - current_poop.global_transform.origin
		run_direction.y = 0.0
		velocity = run_direction.normalized() * mob_speed * 2.0
	
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


func seek(target: Vector3) -> Vector3:
	var desired = target - global_transform.origin
	desired.y = 0  # Flatten to X-Z plane
	desired = desired.normalized() * mob_speed
	var steer = desired - velocity
	if steer.length() > max_force:
		steer = steer.normalized() * max_force
	return steer


func wander_robot() -> Vector3:
	
	var target_distance = target_position - global_transform.origin
	target_distance.y = 0  # Flatten to X-Z plane
	if target_distance.length() < 1.0:
		refresh_direction()
		timer.start()
		return Vector3.ZERO
	
	return seek(target_position)


func wander_human() -> Vector3:
	var future = global_transform.origin + velocity.normalized() * wander_ring_distance
	var offset = Vector3(wander_ring_radius, 0, 0).rotated(Vector3.UP, randf_range(0, TAU))
	var target = future + offset
	displacement = target
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
	if wander_type == WanderType.ROBOT:
		return
	if debug_on:
		set_color(Color.RED)
	running_from_poop = true
	current_poop = poop


func exited_poop(_poop):
	if wander_type == WanderType.ROBOT:
		return
	if debug_on:
		set_color(Color.WHITE)
	running_from_poop = false


func set_color(color: Color):
	var color_material = StandardMaterial3D.new()
	color_material.albedo_color = color
	find_child("NPC").get_child(0).get_child(0).get_child(0).material_override = color_material
	find_child("NPC").get_child(0).get_child(0).get_child(1).material_override = color_material
	find_child("NPC").get_child(0).get_child(0).get_child(2).material_override = color_material
	find_child("NPC").get_child(0).get_child(0).get_child(3).material_override = color_material
	find_child("NPC").get_child(0).get_child(0).get_child(4).material_override = color_material
	find_child("NPC").get_child(0).get_child(0).get_child(5).material_override = color_material
	
