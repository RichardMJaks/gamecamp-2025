extends FSMState

@onready var player: Player = owner
@export var move_state: FSMState
@export var timer: Timer
@export var launch_force: float = 20

func _ready() -> void:
	timer.timeout.connect(
		change_state.emit.bind(move_state)
	)

func enter() -> void:
	_launch()

func _launch() -> void:
	# Add launch velocity
	print("Launched")
	var dir = player.current_magnet.magnet_gravity_direction
	player.velocity += launch_force * GlobalVars.su * dir
	player.position += player.velocity.normalized() * 0.001
	change_state.emit(move_state)

func exit() -> void:
	# Clamp the speed at the exit to maximum player speed
	player.velocity = player.velocity.normalized() * min(player.velocity.length(), player.speed)
