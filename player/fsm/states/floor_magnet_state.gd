extends FSMState

@onready var player: Player = owner
@export var move_state: FSMState
@export var launch_force: float = 20
@export var whoosh: AudioStreamPlayer
@export var launch_particles: GPUParticles2D
@export var shake_intensity: float
@export var shake_time: float
@export var floor_launch_particles: PackedScene
@export var afterimages: Node
var dir: Vector2 = Vector2.ZERO




func enter() -> void:
	_launch()
	afterimages.create_afterimages()
	change_state.emit(move_state)


func _launch() -> void:
	_launch_player()
	_play_effects()


func _emit_floor_launch_particles() -> void:
	var flp = floor_launch_particles.instantiate()
	get_tree().current_scene.add_child(flp)
	flp.global_position = player.global_position
	flp.rotation = player.up_direction.angle() + PI / 2


func _emit_launch_particles() -> void:
	launch_particles.emitting = false
	launch_particles.emitting = true


func _launch_player() -> void:
	dir = player.current_magnet.magnet_gravity_direction
	player.velocity += launch_force * GlobalVars.su * dir


func _play_effects() -> void:
	_emit_floor_launch_particles()
	_emit_launch_particles()
	if player.camera:
		player.camera.shake(shake_intensity, shake_time)
	whoosh.play()
