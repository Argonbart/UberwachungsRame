extends Camera3D

@export var move_speed := 10.0
@export var look_sensitivity := 0.005
@export var sprint_multiplier := 3.0

var _rotation := Vector2()  # Stores yaw (x) and pitch (y)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_rotation.x -= event.relative.x * look_sensitivity
		_rotation.y -= event.relative.y * look_sensitivity
		_rotation.y = clamp(_rotation.y, -PI/2, PI/2)  # Prevent flipping

		rotation = Vector3(_rotation.y, _rotation.x, 0)

	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta: float) -> void:
	var direction := Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	if Input.is_action_pressed("move_up"):
		direction += transform.basis.y
	if Input.is_action_pressed("move_down"):
		direction -= transform.basis.y

	direction = direction.normalized()

	var current_speed := move_speed
	if Input.is_action_pressed("sprint"):
		current_speed *= sprint_multiplier

	position += direction * current_speed * delta
