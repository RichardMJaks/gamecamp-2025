extends CharacterBody2D
class_name Player

signal died

@export var spawn_position: Vector2 = Vector2.ZERO

# Define the signal for state changes
@warning_ignore("unused_signal")
signal movement_state_changed(state_name: String)

@onready var su = GlobalVars.su

var being_attracted: bool = false
var current_magnet: Magnet = null
var radial_stuck_fix: bool = false

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
@export var anim_tree: AnimationTree

var accel_time_delta: float = 0
var current_pole: GlobalVars.POLE = GlobalVars.POLE.NORTH

func _ready() -> void:
	add_to_group("player")
	
	# Store initial spawn position if not set in Inspector
	if spawn_position == Vector2.ZERO:
		spawn_position = global_position

func _process(_delta: float) -> void:
	anim_tree["parameters/Idle/blend_position"] = float(current_pole)
	anim_tree["parameters/SwitchPole/blend_position"] = float(current_pole)
	anim_tree["parameters/Walk/blend_position"] = float(current_pole)
	anim_tree["parameters/Flying/blend_position"] = float(current_pole)

	anim_tree["parameters/conditions/switched_pole"] = false
	if has_node("%Label"):
		%Label.text = GlobalVars.POLE.find_key(current_pole)
	
	# Debug pole switching
	if Input.is_action_just_pressed(&"a_switch"):
		@warning_ignore("int_as_enum_without_cast")
		current_pole = 1 - current_pole
		print("Switched pole to: ", GlobalVars.POLE.find_key(current_pole))
		anim_tree["parameters/conditions/switched_pole"] = true

func _physics_process(_delta: float) -> void:
	if is_on_floor():
		anim_tree["parameters/conditions/flying"] = false
		if velocity.length_squared() > 0:
			anim_tree["parameters/conditions/walking"] = true
			anim_tree["parameters/conditions/idling"] = false
		else:
			anim_tree["parameters/conditions/idling"] = true
			anim_tree["parameters/conditions/walking"] = false
	else:
			anim_tree["parameters/conditions/flying"] = true
			anim_tree["parameters/conditions/idling"] = false
			anim_tree["parameters/conditions/walking"] = false

	move_and_slide()

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

# Call this function when the player dies (falls into a pit, touches an enemy, etc.)
func die():
	# Notify game controller
	GameController.handle_player_died()
	
	# Emit signal for other game elements to respond
	emit_signal("died")
	
	# Reset player position
	global_position = spawn_position
	
	# Reset any player state (health, abilities, etc.)
	velocity = Vector2.ZERO

	
	# Reset level collectibles count in GameController
	if GameController.current_level_name != "":
		GameController.levels_data[GameController.current_level_name].collectibles_count = 0
		GameController.collectible_collected.emit(0)
