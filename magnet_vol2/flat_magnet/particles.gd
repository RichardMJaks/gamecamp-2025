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
	if owner.pole == GlobalVars.POLE.NORTH:
		texture = north_particle
		process_material.color = north_color
	if owner.pole == GlobalVars.POLE.SOUTH:
		texture = south_particle
		process_material.color = south_color