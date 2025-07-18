extends Sprite3D


const DIRECTION_CHANGE_TIME: float = 0.3
const MOVEMENT_SPEED: float = 3.0

var _change_direction_timer: float = 0.0
var _random_direction: Vector3 = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()


func _process(delta: float) -> void:
	
	_change_direction_timer += delta
	if _change_direction_timer > DIRECTION_CHANGE_TIME:
		_random_direction = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()
		_change_direction_timer = 0.0
	
	# Calculate the target rotation
	var current_forward = -transform.basis.z.normalized()
	var target_forward = _random_direction.normalized()
	
	if target_forward.length() > 0.001:
		var up = Vector3.UP
		var target_basis = Basis().looking_at(target_forward, up)
		
		# Instead of instantly applying it, store for tweening
		rotation = rotation.slerp(target_basis.get_euler(), delta * 3.0) # optional smooth transition

	position += _random_direction * delta * MOVEMENT_SPEED
