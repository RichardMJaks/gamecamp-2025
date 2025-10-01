extends FSMState

@export var move_state: FSMState
@export var custom_rotation_speed: float = 1:
	get:
		if Engine.is_editor_hint():
			return custom_rotation_speed
		return custom_rotation_speed * GlobalVars.su
@export var doing: AudioStreamPlayer
@export var launch_particles: GPUParticles2D
@export var camera: Camera2D
@export var shake_intensity: float
@export var shake_time: float
@export var ejection_force: float = 10

var rotation_vector: Vector2:
	get:
		return rotation_vector.normalized()
var rotation_distance: float = 0:
	get:
		return max (rotation_distance, 0.0001) # Failsafe incase rotation distance is really small
var rotation_direction: int = 0
var rotation_speed: float = 0
var magnet_position: Vector2 = Vector2.ZERO
var ejecting: bool = false

@onready var player: Player = owner

func enter() -> void:
	var player_position: Vector2 = player.global_position

	# Initialize correct values for rotation
	magnet_position = player.current_magnet.global_position
	rotation_vector = (player_position - magnet_position).normalized()
	rotation_distance = player_position.distance_to(magnet_position) #FIXME: Make it a constant value, taken from the radial magnet
	rotation_direction = player.current_magnet.rotation_direction
	rotation_speed = _calculate_rotation_speed(custom_rotation_speed, rotation_distance)

func __physics_process(delta) -> void:
	if not ejecting:
		rotation_vector = rotation_vector.rotated(rotation_speed * rotation_direction * delta)
		player.global_position = magnet_position + rotation_vector * rotation_distance
	player.up_direction = rotation_vector #HACK: This is really hacky, I understand time limit was the reason but WHY???
	_handle_ejection()

# This function fixes a bug where you get stuck in the radial magnet for multiple jumps
func _handle_ejection() -> void:
	# We can assume that this will switch the poles to match
	if Input.is_action_just_pressed(&"a_switch") and not ejecting:
		_eject()

	if ejecting and not player.current_magnet:
		change_state.emit(move_state)

func _eject() -> void:
	doing.play()
	camera.shake(shake_intensity, shake_time)
	launch_particles.emitting = false
	launch_particles.emitting = true
	var ejection_direction = rotation_vector.rotated(rotation_direction)
	player.velocity = ejection_direction * ejection_force * GlobalVars.su
	ejecting = true

func exit() -> void:
	ejecting = false

# Returns angular rotation speed (in radians)
# To keep rotation speeds consistent
func _calculate_rotation_speed(speed: float, distance: float) -> float:
	return speed / distance
