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

func _launch() -> void:
	# Add launch velocity
	print("Launched")
	var flp = floor_launch_particles.instantiate()
	get_tree().current_scene.add_child(flp)
	flp.global_position = player.global_position
	flp.rotation = player.up_direction.angle() + PI / 2
	camera.shake(shake_intensity, shake_time)
	launch_particles.emitting = false
	launch_particles.emitting = true
	var dir = player.current_magnet.magnet_gravity_direction
	player.velocity += launch_force * GlobalVars.su * dir
	player.position += player.velocity.normalized() * 0.001
	whoosh.play()
	change_state.emit(move_state)

func exit() -> void:
	# Clamp the speed at the exit to maximum player speed
	player.velocity = player.velocity.normalized() * min(player.velocity.length(), player.speed)
