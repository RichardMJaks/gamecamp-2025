@tool
extends Node2D

@export var left_particles: ParticleProcessMaterial
@export var right_particles: ParticleProcessMaterial
@export var rim_particles: ParticleProcessMaterial

@export var north_particles: Texture2D
@export var south_particles: Texture2D
@export var north_color: Color
@export var south_color: Color

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
		left_rotating.emitting = true
		right_rotating.emitting = false
	if magnet.rotation_direction == -1:
		left_rotating.emitting = false
		right_rotating.emitting = true

	if magnet.pole == GlobalVars.POLE.NORTH:
		left_rotating.texture = north_particles
		right_rotating.texture = north_particles
		left_rotating.process_material.color = north_color
		right_rotating.process_material.color = north_color
	if magnet.pole == GlobalVars.POLE.SOUTH:
		left_rotating.texture = south_particles
		right_rotating.texture = south_particles
		left_rotating.process_material.color = south_color
		right_rotating.process_material.color = south_color
