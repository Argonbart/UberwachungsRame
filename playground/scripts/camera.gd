extends Camera3D


func _process(_delta):
	look_at(Vector3.ZERO + Vector3(0.0, -20.0, 0.0))
