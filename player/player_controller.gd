extends CharacterBody2D
class_name Player

# Define the signal for state changes
@warning_ignore("unused_signal")
signal movement_state_changed(state_name: String)

@onready var su = GlobalVars.su

var being_attracted: bool = false
var current_magnet: Magnet = null

@export var speed: float = 300.0:
	get:
		if Engine.is_editor_hint():
			return speed
		return speed * GlobalVars.su
@export var acceleration_time: float = 0.2
@export var deceleration_time: float = 0.1
@export var jump_height: float = 100.0
@export var gravity_direction: Vector2i = Vector2i(0, 1):
	set(value):
		if value.x != 0:
			value.y = 0
			gravity_direction = value
		else:
			value.x = 0
			gravity_direction = value	

@export var radial_magnet_state: FSMState

var accel_time_delta: float = 0
var current_pole: GlobalVars.POLE = GlobalVars.POLE.NORTH

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if has_node("%Label"):
		%Label.text = GlobalVars.POLE.find_key(current_pole)
	
	# Debug pole switching
	if Input.is_action_just_pressed(&"a_switch"):
		@warning_ignore("int_as_enum_without_cast")
		current_pole = 1 - current_pole
		print("Switched pole to: ", GlobalVars.POLE.find_key(current_pole))

func _physics_process(_delta: float) -> void:
	_handle_floor_magnet()
	_handle_radial_magnet()
	move_and_slide()

func _handle_floor_magnet() -> void:
	if not current_magnet or not current_magnet is FloorMagnet:
		gravity_direction = Vector2.DOWN
		return
	var magnet_gravity_direction = current_magnet.magnet_gravity_direction
	var poles_different: bool = current_pole != current_magnet.pole 
	if poles_different:
		gravity_direction = magnet_gravity_direction
	else:
		gravity_direction = -magnet_gravity_direction

func _handle_radial_magnet() -> void:
	if not current_magnet or not current_magnet is RadialMagnet or radial_magnet_state.ejecting:
		return
	var poles_different: bool = current_pole != current_magnet.pole 
	if not poles_different:
		velocity = _calculate_radial_bounce_angle(current_magnet) * get_gravity().y

func _calculate_radial_bounce_angle(magnet: RadialMagnet) -> Vector2:
	var magnet_position = magnet.global_position
	var dir_to_player = global_position - magnet_position
	dir_to_player = -dir_to_player.normalized()
	var velocity_normalized = velocity.normalized()
	var reflection_dot = dir_to_player.dot(velocity_normalized)

	return velocity_normalized - 2 * reflection_dot * dir_to_player

func _get_jump_height(h: float) -> float:
	return sqrt(2 * get_gravity().y * h)

func _on_entered_magnet_range(area:Area2D) -> void:
	if not area is Magnet:
		return
	
	current_magnet = area


func _on_exited_magnet_range(area:Area2D) -> void:
	if not area is Magnet:
		return

	current_magnet = null
