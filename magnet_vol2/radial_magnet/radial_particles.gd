extends Node2D

@export var left_particles: ParticleProcessMaterial
@export var right_particles: ParticleProcessMaterial
@export var rim_particles: ParticleProcessMaterial

@export var magnet: RadialMagnet
@export var collider: CollisionShape2D

var radius: float = 32
@onready var left_rotating: GPUParticles2D = $InnerParticlesLeft
@onready var right_rotating: GPUParticles2D = $InnerParticlesRight
@onready var outer_ring: GPUParticles2D = $OuterRim


func _ready() -> void:
	left_rotating.process_material = left_particles.duplicate()
	right_rotating.process_material = right_particles.duplicate()
	outer_ring.process_material = rim_particles.duplicate()

func _process(_delta: float) -> void:
	if magnet.rotation_direction == 1:
		left_rotating.visible = true
		right_rotating.visible = false
	if magnet.rotation_direction == -1:
		left_rotating.visible = false
		right_rotating.visible = true


	
