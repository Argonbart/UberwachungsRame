extends Area3D


@export var area_size: Vector2
@export_color_no_alpha var area_color
@export_category("Nodes")
@export var collision_shape: CollisionShape3D
@export var gpu_particles: GPUParticles3D
@export var border_box: CSGBox3D
@export var border_box_cut: CSGBox3D

func _ready():
	
	# collision shape
	var box_shape: BoxShape3D = collision_shape.shape
	box_shape.size.x = area_size.x
	box_shape.size.z = area_size.y
	
	# particles
	gpu_particles.visibility_aabb.size.x = area_size.x
	gpu_particles.visibility_aabb.size.z = area_size.y
	gpu_particles.visibility_aabb.position.x = -area_size.x/2.0
	gpu_particles.visibility_aabb.position.z = -area_size.x/2.0
	var particles_material: ParticleProcessMaterial = gpu_particles.process_material
	particles_material.emission_shape_scale.x = area_size.x / 2.0
	particles_material.emission_shape_scale.z = area_size.y / 2.0
	
	# border box
	border_box.size.x = area_size.x
	border_box.size.z = area_size.y
	
	# border box
	border_box_cut.size.x = area_size.x - 0.1
	border_box_cut.size.z = area_size.y - 0.1
	
	# colors
	var color_material: StandardMaterial3D = StandardMaterial3D.new()
	color_material.albedo_color = area_color
	border_box.material = color_material
	var box_mesh: BoxMesh = BoxMesh.new()
	box_mesh.surface_set_material(0, color_material)
	gpu_particles.draw_pass_1 = box_mesh
