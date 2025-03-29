extends Node2D

@export_enum("Left:1", "Right:-1") var rotation_direction: int = 1
var radius: float = 32
@onready var left_rotating: GPUParticles2D = $InnerParticlesLeft
@onready var right_rotating: GPUParticles2D = $InnerParticlesRight
@onready var outer_ring: GPUParticles2D = $OuterRim


func _ready() -> void:
	left_rotating.process_material = left_rotating.process_material.duplicate()
	right_rotating.process_material = right_rotating.process_material.duplicate()
	outer_ring.process_material = outer_ring.process_material.duplicate()
	
