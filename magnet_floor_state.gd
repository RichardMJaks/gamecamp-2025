extends PlayerMovementState

var current_magnet: FloorMagnet
var is_sticking: bool = false
var push_force: float = 200.0  # Force when poles are opposite
var launch_power: float = 800.0  # Power when poles are switched while sticking

func _ready() -> void:
	state_name = "MagnetFloor"

func enter() -> void:
	# The current magnet should be set before entering this state
	if current_magnet == null:
		state_machine.change_state("NormalMove")
		return
	
	# Check pole interaction
	check_pole_interaction()

func exit() -> void:
	is_sticking = false
	current_magnet = null

func check_pole_interaction() -> void:
	# If poles are the same, stick to center
	if player.current_pole == current_magnet.pole:
		is_sticking = true
		# Set gravity direction based on magnet orientation
		player.gravity_direction = current_magnet.magnet_gravity_direction
		player.up_direction = -player.gravity_direction
	else:
		# If poles are opposite, prepare to push
		is_sticking = false

func physics_update(delta: float) -> void:
	if current_magnet == null:
		state_machine.change_state("NormalMove")
		return
	
	# Check if player switched poles
	if Input.is_action_just_pressed(&"a_switch"):
		@warning_ignore("int_as_enum_without_cast")
		player.current_pole = 1 - player.current_pole
		
		# If player was sticking and switched to opposite pole, launch them
		if is_sticking and player.current_pole != current_magnet.pole:
			is_sticking = false
			
			# Calculate launch direction (away from magnet)
			var launch_direction = (player.global_position - current_magnet.global_position).normalized()
			var launch_velocity = launch_direction * launch_power
			
			# Enter static velocity state with the launch velocity
			var static_state = state_machine.states.get("StaticVelocity")
			if static_state:
				static_state.set_launch_velocity(launch_velocity)
				state_machine.change_state("StaticVelocity")
				return
		else:
			# Update sticking status based on new pole
			check_pole_interaction()
	
	if is_sticking:
		# Apply a small gravity to keep player grounded if needed
		apply_minimal_gravity(delta)
	else:
		# Poles are opposite, gently push away
		var push_direction = (player.global_position - current_magnet.global_position).normalized()
		player.velocity = push_direction * push_force * delta
		
		# Allow some limited player control while being pushed
		var input_dir = Input.get_vector(&"m_left", &"m_right", &"m_up", &"m_down")
		var control_influence = 0.7  # Player has 30% control while being pushed
		player.velocity += input_dir * player.speed * control_influence * delta

# Apply just enough gravity to keep player on ground
func apply_minimal_gravity(delta: float) -> void:
	if player.gravity_direction.x == 0:  # Vertical gravity
		if not player.is_on_floor():
			player.velocity.y += player.get_gravity().y * 0.1 * delta * player.gravity_direction.y
	else:  # Horizontal gravity
		if not player.is_on_floor():
			player.velocity.x += player.get_gravity().y * 0.1 * delta * player.gravity_direction.x
