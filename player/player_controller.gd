class_name Player
extends CharacterBody2D

signal died
@warning_ignore("unused_signal")
signal movement_state_changed(state_name: String)

@export var spawn_position: Vector2 = Vector2.ZERO
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
@export var switched: AudioStreamPlayer
@export var switch_particles: GPUParticles2D
@export var color_north: Color
@export var color_south: Color
@export var current_pole: GlobalVars.POLE = GlobalVars.POLE.NORTH
@export var camera_transform: RemoteTransform2D
@export var controlled_state: FSMState

var being_attracted: bool = false
var current_magnet: Magnet = null
var radial_stuck_fix: bool = false
var accel_time_delta: float = 0
var camera: Camera2D = null

@onready var su = GlobalVars.su


func _ready() -> void:
	add_to_group("player") #FIXME: Remind me what the group was used for
	
	# Store initial spawn position if not set in Inspector
	if spawn_position == Vector2.ZERO:
		spawn_position = global_position

func _process(_delta: float) -> void:
	# Reset this so it would be a toggle instead
	anim_tree["parameters/conditions/switched_pole"] = false
	_set_anim_tree_blend_positions(float(current_pole))
	
	# Debug pole switching
	if has_node("%Label"):
		%Label.text = GlobalVars.POLE.find_key(current_pole)

	if Input.is_action_just_pressed(&"a_switch"):
		_toggle_pole()

func _physics_process(_delta: float) -> void:
	_set_anim_tree_parameters()
	move_and_slide()

func set_camera(scene_camera: Camera2D) -> void:
	camera = scene_camera
	camera_transform.remote_path = camera_transform.get_path_to(camera)


# Doesn't seem to be in use
func _calculate_radial_bounce_angle(magnet: RadialMagnet) -> Vector2:
	var magnet_position = magnet.global_position
	var dir_to_player = global_position - magnet_position
	dir_to_player = -dir_to_player.normalized()
	var velocity_normalized = velocity.normalized()
	var reflection_dot = dir_to_player.dot(velocity_normalized)
	
	return velocity_normalized - 2 * reflection_dot * dir_to_player

func _get_jump_height(h: float) -> float:
	return sqrt(2 * get_gravity().y * h)


# Call this function when the player dies (falls into a pit, touches an enemy, etc.)
# Not in use currently
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

func _toggle_pole() -> void:
	if not current_magnet:
		switched.play()
	if current_pole == GlobalVars.POLE.NORTH:
		switch_particles.process_material.color = color_south
	if current_pole == GlobalVars.POLE.SOUTH:
		switch_particles.process_material.color = color_north
	switch_particles.restart()
	switch_particles.emitting = true
	@warning_ignore("int_as_enum_without_cast")
	current_pole = 1 - current_pole
	anim_tree["parameters/conditions/switched_pole"] = true


func set_controlled() -> void:
	%StateMachine._change_to_state(controlled_state)
	anim_tree["parameters/conditions/controlled"] = true

#region Signal connections
func _on_entered_magnet_range(area:Area2D) -> void:
	if not area is Magnet:
		return
	
	current_magnet = area


func _on_exited_magnet_range(area:Area2D) -> void:
	if not area is Magnet:
		return

	current_magnet = null
#endregion

#region Animation Helpers
func _set_anim_tree_blend_positions(pole_blend_position: float) -> void:
	anim_tree["parameters/Idle/blend_position"] = pole_blend_position 
	anim_tree["parameters/SwitchPole/blend_position"] = pole_blend_position
	anim_tree["parameters/Walk/blend_position"] = pole_blend_position
	anim_tree["parameters/Flying/blend_position"] = pole_blend_position
	anim_tree["parameters/Controlled/blend_position"] = pole_blend_position


func _set_anim_tree_parameters() -> void:
	if not is_on_floor():
		_set_anim_fly()
		return
	
	if velocity.length_squared() > 0:
		_set_anim_walk()
		return

	_set_anim_idle()

func _set_anim_idle() -> void:
	anim_tree["parameters/conditions/flying"] = false
	anim_tree["parameters/conditions/idling"] = true
	anim_tree["parameters/conditions/walking"] = false

func _set_anim_walk() -> void:
	anim_tree["parameters/conditions/flying"] = false
	anim_tree["parameters/conditions/idling"] = false 
	anim_tree["parameters/conditions/walking"] = true 

func _set_anim_fly() -> void:
	anim_tree["parameters/conditions/flying"] = true 
	anim_tree["parameters/conditions/idling"] = false
	anim_tree["parameters/conditions/walking"] = false
#endregion
