@tool
extends GPUParticles2D

@export var collider: CollisionShape2D
@export var south_particle: Texture2D
@export var north_particle: Texture2D
@export var south_color: Color
@export var north_color: Color
@export var particles_material: ParticleProcessMaterial


func _ready() -> void:
	process_material = particles_material.duplicate()

func _process(_delta: float) -> void:
	position = collider.position
	_apply_particle()
	var box_size: Vector2 = collider.shape.size
	process_material.emission_box_extents.x = box_size.x / 2 - 5
	process_material.emission_box_extents.y = box_size.y / 2 - 5


func _apply_particle():
	if get_parent().pole == GlobalVars.POLE.NORTH:
		texture = north_particle
		process_material.color = north_color
	if get_parent().pole == GlobalVars.POLE.SOUTH:
		texture = south_particle
		process_material.color = south_color
	var dir = get_parent().magnet_direction
	if dir == 0:
		process_material.direction = Vector3(-1, 0, 0)
	if dir == 1:
		process_material.direction = Vector3(1, 0, 0)
	if dir == 2:
		process_material.direction = Vector3(0, -1, 0)
	if dir == 3:
		process_material.direction = Vector3(0, 1, 0)