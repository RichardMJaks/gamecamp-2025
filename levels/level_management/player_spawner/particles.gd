@tool
extends Node2D

@export_tool_button("Emit") var emit_particles = emit

func emit() -> void:
	for child: GPUParticles2D in get_children():
		child.emitting = true