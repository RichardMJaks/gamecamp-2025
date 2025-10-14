extends FSMState

# Imma just say, due to gravity changing not working intuitively
# this whole script contains absolute shit code, with nested if-s
# and in general confusing maths. Just accept the fact that first
# if block handles horizontal, and the else or elif handles vertical
# movement.

@onready var player: Player = owner
@export var floor_magnet_state: FSMState
@export var radial_magnet_state: FSMState
@export var doing: AudioStreamPlayer
@export var magnet_check_raycast: RayCast2D
var radial_stuck_fix: bool = false
var player_movement_velocity: Vector2 = Vector2.ZERO
var player_gravity_velocity: Vector2 = Vector2.ZERO
var exiting = false

func __physics_process(delta: float) -> void:
	if exiting:
		return
	# Use this to return -1, 0, or 1
	var get_rounded_axis: Callable = func (a1: StringName, a2: StringName) -> int:
		return ceili(Input.get_action_strength(a2)) - ceili(Input.get_action_strength(a1))

	# Get input direction
	@warning_ignore("narrowing_conversion")
	var dir: Vector2i = Vector2i( 
		get_rounded_axis.call(&"m_left", &"m_right"), 
		get_rounded_axis.call(&"m_up", &"m_down")
	)

	# Calculate acceleration and deceleration
	_accelerate_player(dir, delta)
	_decelerate_player(dir, delta)
	_apply_gravity(delta)

	_handle_floor_magnet()
	_handle_radial_magnet()

	#_handle_jump()

	if Input.is_action_just_pressed(&"a_switch"):
		_trigger_floor_magnet_action()

	trigger_radial_magnet_action()
	# Update player's up direction based on gravity
	player.up_direction = -player.gravity_direction	
	

# !! TREAD CAREFULLY IN THIS REGION !!
# (or better yet, save your braincells and never open it)
#region Movement functions
# Accelerate player when having forward direction
func _accelerate_player(dir: Vector2i, delta) -> void:
	## If-else to handle both horizontal and vertical movement when needed
	## Horizontal movement
	if player.gravity_direction.x == 0 and dir.x:
		_apply_acceleration(dir.x, delta, Vector2.RIGHT)
	# Vertical movement
	if player.gravity_direction.y == 0 and dir.y:
		_apply_acceleration(dir.y, delta, Vector2.DOWN)


# Applies acceleration with respect to current movement axis
func _apply_acceleration(dir: float, delta: float, axis: Vector2) -> void:
	var acceleration: float = player.speed / player.acceleration_time
	if (player.velocity * axis).length() < player.speed:
		player.velocity += dir * acceleration * delta * axis
	else:
		player.velocity = player.velocity.move_toward(player.velocity.normalized() * player.speed, acceleration * delta)


# Apply deceleration when no input or changing direction
func _decelerate_player(dir: Vector2i, delta) -> void:
	var deceleration: float = player.speed / player.deceleration_time
	# I am aware this if-else looks horrible, but this is the most readable
	if player.gravity_direction.x == 0:
		if sign(dir.x) != sign(player.velocity.x):
			player.velocity.x = move_toward(player.velocity.x, 0, deceleration * delta)
	else:
		if sign(dir.y) != sign(player.velocity.y):
			player.velocity.y = move_toward(player.velocity.y, 0, deceleration * delta)


# Helper methods for common movement patterns
func _apply_gravity(delta: float) -> void:
	if player.gravity_direction.x == 0:
		if not player.is_on_floor():
			player.velocity.y += player.get_gravity().y * delta * player.gravity_direction.y
			#player.velocity.y = clampf(player.velocity.y, -player.max_fall_speed, player.max_fall_speed)
	else:
		if not player.is_on_floor():
			player.velocity.x += player.get_gravity().y * delta * player.gravity_direction.x
			#player.velocity.x = clampf(player.velocity.x, -player.max_fall_speed, player.max_fall_speed)

#func _handle_jump() -> void:
#	if player.gravity_direction.x == 0:
#		if Input.is_action_just_pressed(&"m_jump") and player.is_on_floor():
#			player.velocity.y -= player._get_jump_height(player.jump_height * GlobalVars.su) * player.gravity_direction.y
#	else:
#		if Input.is_action_just_pressed(&"m_jump") and player.is_on_floor():
#			player.velocity.x -= player._get_jump_height(player.jump_height * GlobalVars.su) * player.gravity_direction.x
#endregion

#region Magnet actions
func _trigger_floor_magnet_action() -> void:
	# Guards to not trigger it when not in it
	if not player.current_magnet:
		return
	if not player.current_magnet is FloorMagnet:
		return
	# We can fairly assume that player is not on floor when not being attracted
	
	if not player.is_on_floor():
		return

	# Safeguard that player doesn't boost when they are not actually on a magnet
	# TODO: Create a separate node to handle this logic to clean up here
	if magnet_check_raycast.is_colliding():
		# Subtract player up direction to compensate for the miss being on the border
		var point: Vector2 = magnet_check_raycast.get_collision_point() - player.up_direction * 0.01
		var coll: TileMapLayer = magnet_check_raycast.get_collider()
		var tile_data = coll.get_cell_tile_data(coll.local_to_map(coll.to_local(point)))
		
		if not tile_data:
			return
		if not tile_data.has_custom_data("magnet"):
			return
		if not tile_data.get_custom_data("magnet"):
			return

	change_state.emit(floor_magnet_state)

# This method is called from charactercontroller, due to that
# managing all physics interactions
func trigger_radial_magnet_action() -> void:
	if not player.current_magnet:
		return
	if not player.current_magnet is RadialMagnet:
		return
	var poles_different = player.current_pole != player.current_magnet.pole
	if poles_different:
		change_state.emit(radial_magnet_state)
		return

func _handle_floor_magnet() -> void:
	if not player.current_magnet or not player.current_magnet is FloorMagnet:
		player.gravity_direction = Vector2.DOWN
		return
	var magnet_gravity_direction = player.current_magnet.magnet_gravity_direction
	var poles_different: bool = player.current_pole != player.current_magnet.pole 
	if not poles_different:
		player.gravity_direction = magnet_gravity_direction
	else:
		player.gravity_direction = -magnet_gravity_direction

func _handle_radial_magnet() -> void:
	if not player.current_magnet or not player.current_magnet is RadialMagnet or radial_magnet_state.ejecting:
		radial_stuck_fix = false
		return
	var poles_different: bool = player.current_pole != player.current_magnet.pole 
	if not poles_different and not radial_stuck_fix:
		doing.play() 
		radial_stuck_fix = true
		player.velocity = -player.velocity.normalized() * radial_magnet_state.ejection_force * GlobalVars.su

func _calculate_radial_bounce_angle(magnet: RadialMagnet) -> Vector2:
	doing.play()
	var magnet_position = magnet.global_position
	var dir_to_player = (magnet_position - player.global_position).normalized()
	var velocity_normalized = player.velocity.normalized()

	var cos_dir_to_p_vel = dir_to_player.dot(-velocity_normalized)
	var sin_dir_to_p_vel = sqrt(1 - cos_dir_to_p_vel * cos_dir_to_p_vel)

	var bounce_dir = Vector2(0, 0)
	bounce_dir.x = dir_to_player.x * cos_dir_to_p_vel - dir_to_player.x * sin_dir_to_p_vel
	bounce_dir.y = dir_to_player.x * sin_dir_to_p_vel + dir_to_player.x * cos_dir_to_p_vel
	return bounce_dir
#endregion
