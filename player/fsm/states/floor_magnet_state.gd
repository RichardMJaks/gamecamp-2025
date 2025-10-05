extends FSMState

@onready var player: Player = owner
@export var move_state: FSMState
@export var timer: Timer
@export var launch_force: float = 20
@export var whoosh: AudioStreamPlayer
@export var launch_particles: GPUParticles2D
@export var camera: Camera2D
@export var shake_intensity: float
@export var shake_time: float
@export var floor_launch_particles: PackedScene


func _ready() -> void:
	timer.timeout.connect(
		change_state.emit.bind(move_state)
	)

func enter() -> void:
	_launch()

#FIXME: Players gets stuck on walls and such, fix it
func _launch() -> void:
	# Add launch velocity
	print("Launched")
	_launch_player()
	_play_effects()
	change_state.emit(move_state)


func _emit_floor_launch_particles() -> void:
	var flp = floor_launch_particles.instantiate()
	get_tree().current_scene.add_child(flp)
	flp.global_position = player.global_position
	flp.rotation = player.up_direction.angle() + PI / 2


func _emit_launch_particles() -> void:
	launch_particles.emitting = false
	launch_particles.emitting = true


func _launch_player() -> void:
	var dir = player.current_magnet.magnet_gravity_direction
	player.velocity += launch_force * GlobalVars.su * dir
	player.position += player.velocity.normalized() * 0.001


func _play_effects() -> void:
	_emit_floor_launch_particles()
	_emit_launch_particles()
	camera.shake(shake_intensity, shake_time)
	whoosh.play()



func exit() -> void:
	# Clamp the speed at the exit to maximum player speed
	player.velocity = player.velocity.normalized() * min(player.velocity.length(), player.speed)
