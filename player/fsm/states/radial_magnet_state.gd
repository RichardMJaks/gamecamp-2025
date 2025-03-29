extends FSMState

@export var move_state: FSMState
@export var custom_rotation_speed: float = 1:
	get:
		if Engine.is_editor_hint():
			return custom_rotation_speed
		return custom_rotation_speed * GlobalVars.su
@onready var player: Player = owner
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

func enter() -> void:
	var player_position: Vector2 = player.global_position

	# Initialize correct values for rotation
	magnet_position = player.current_magnet.global_position
	rotation_vector = (player_position - magnet_position).normalized()
	rotation_distance = player_position.distance_to(magnet_position)
	rotation_direction = player.current_magnet.rotation_direction
	rotation_speed = _calculate_rotation_speed(custom_rotation_speed, rotation_distance)

func __physics_process(delta) -> void:
	if not ejecting:
		rotation_vector = rotation_vector.rotated(rotation_speed * rotation_direction * delta)
		player.global_position = magnet_position + rotation_vector * rotation_distance
	player.up_direction = rotation_vector
	_handle_ejection()


func _handle_ejection() -> void:
	# We can assume that this will switch the poles to match
	if Input.is_action_just_pressed(&"a_switch") and not ejecting:
		var ejection_direction = rotation_vector.rotated(PI/2*rotation_direction)
		player.velocity = ejection_direction * player.get_gravity().y
		ejecting = true

	if ejecting and not player.current_magnet:
		change_state.emit(move_state)

func exit() -> void:
	ejecting = false

# Returns angular rotation speed (in radians)
# To keep rotation speeds consistent
func _calculate_rotation_speed(speed: float, distance: float) -> float:
	return speed / distance
