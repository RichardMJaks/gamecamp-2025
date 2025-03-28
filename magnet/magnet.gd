extends Node2D
class_name Magnet

@export var particles: GPUParticles2D
@export var pole: GlobalVars.POLE = GlobalVars.POLE.NORTH
@export var radius: float = 1
@export var strength: float = 1
@export var flat: bool = false
@export var flat_dir_vector = Vector2.ZERO
@onready var effect_range: Area2D = %MagnetRange
var player: Player = null

func _process(_delta: float) -> void:
	effect_range.get_child(0).shape.radius = radius
	particles.process_material.emission_ring_inner_radius = radius - 10
	particles.process_material.emission_ring_radius = radius
	


func _physics_process(delta: float) -> void:
	if not player:
		return

	var dir: float = player.current_pole * pole
	var vector: Vector2 = player.global_position - global_position
	vector = vector.normalized()
	var force: float = strength * player.get_gravity().y
	var velocity: Vector2 = dir * vector * force
	var damping: float = 1 - velocity.normalized().dot(player.velocity.normalized()) * (dir * -1)
	player.velocity += velocity * delta * (1 - damping * GlobalVars.magnet_damping)
	print(damping)

func _on_range_entered(area: Area2D) -> void:
	if not area.owner is Player:
		return
	
	player = area.owner
	player.magnets.append(self)


func _on_range_exited(area: Area2D) -> void:
	if not area.owner is Player:
		return

	player.magnets.erase(self)
	player = null
