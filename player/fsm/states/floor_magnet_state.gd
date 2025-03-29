extends FSMState

@onready var player: Player = owner
@export var move_state: FSMState
@export var travel_distance: float = 5
@export var travel_time: float = 0.5
@export var timer: Timer

func _ready() -> void:
	timer.timeout.connect(
		change_state.emit.bind(move_state)
	)

func enter() -> void:
	_launch()

func _launch() -> void:
	# Add launch velocity
	var inital_velocity = _calculate_velocity()
	var dir = -player.current_magnet.magnet_gravity_direction
	player.velocity = inital_velocity * dir

	# Start timer to exit this state
	timer.wait_time = travel_time
	timer.start()

func exit() -> void:
	# Clamp the speed at the exit to maximum player speed
	timer.stop()
	player.velocity = player.velocity.normalized() * min(player.velocity.length(), player.speed)

func _calculate_velocity() -> float:
	var real_distance: float = travel_distance * GlobalVars.su
	return real_distance / travel_time
