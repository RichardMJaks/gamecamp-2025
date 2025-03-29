extends PlayerMovementState

var current_magnet: RadialMagnet
var hook_range: float = 300.0  # Maximum distance to hook to magnet
var orbital_speed: float = 250.0  # Speed of rotation around magnet
var orbital_radius: float = 80.0  # Distance from magnet center to orbit
var rotation_angle: float = 0.0  # Current angle of rotation
var is_hooked: bool = false
var is_lerping: bool = false
var lerp_speed: float = 5.0  # Speed of lerping to the orbit
var launch_power: float = 800.0  # Power of the launch when jumping
var tangent_direction: Vector2 = Vector2.ZERO  # Current direction of movement around the magnet

func _ready() -> void:
	state_name = "MagnetRadial"
	print("MagnetRadial state initialized")

func enter() -> void:
	print("Entering MagnetRadial state")
	# The current magnet should be set before entering this state
	if current_magnet == null:
		print("No current magnet set, reverting to NormalMove")
		state_machine.change_state("NormalMove")
		return
	
	# Initialize rotation angle based on player's current position relative to magnet
	var to_player = player.global_position - current_magnet.global_position
	rotation_angle = atan2(to_player.y, to_player.x)
	
	# Start in lerping state
	is_hooked = false
	is_lerping = true
	
	print("MagnetRadial state entered successfully")

func exit() -> void:
	print("Exiting MagnetRadial state")
	is_hooked = false
	is_lerping = false
	current_magnet = null
	tangent_direction = Vector2.ZERO

func physics_update(delta: float) -> void:
	if current_magnet == null:
		print("Current magnet is null, reverting to NormalMove")
		state_machine.change_state("NormalMove")
		return
	
	# Check if player and magnet polarities still match for attraction
	var polarity_match = (player.current_pole != current_magnet.pole)  # Opposite poles attract
	if !polarity_match:
		print("Polarity mismatch, launching player away")
		# If polarities don't match anymore, launch the player away
		launch_player(-1.0)  # Negative multiplier for repulsion
		return
		
	# If player is still in lerping phase (moving toward orbit)
	if is_lerping:
		lerp_to_orbit(delta)
	# If player is hooked to the magnet and orbiting
	elif is_hooked:
		orbit_around_magnet(delta)
	
	# Handle jump input at any time to launch away
	if Input.is_action_just_pressed(&"m_jump"):
		print("Jump pressed, launching player")
		launch_player(1.0)  # Normal launch direction

# Lerp the player toward the orbital position
func lerp_to_orbit(delta: float) -> void:
	var to_magnet = current_magnet.global_position - player.global_position
	var distance = to_magnet.length()
	
	if distance <= hook_range:
		# Calculate the target position at orbital radius
		var direction = to_magnet.normalized()
		var target_position = current_magnet.global_position - direction * orbital_radius
		
		# Lerp toward the orbital position
		var lerp_velocity = (target_position - player.global_position) * lerp_speed
		player.velocity = lerp_velocity
		
		# Print debug info
		print("Lerping to orbit - Distance: ", distance, ", Target: ", target_position)
		
		# Once close enough to orbital radius, start circular motion
		if abs(distance - orbital_radius) < 10:
			print("Close enough to orbit, starting circular motion")
			is_lerping = false
			is_hooked = true
	else:
		print("Too far from magnet, reverting to NormalMove")
		# Too far from the magnet, return to normal movement
		state_machine.change_state("NormalMove")

# Make the player orbit around the magnet
func orbit_around_magnet(delta: float) -> void:
	# Determine rotation direction based on player's input
	var rotation_direction = 1.0  # Default clockwise
	var input_dir = Input.get_vector(&"m_left", &"m_right", &"m_up", &"m_down")
	
	# Left/right input changes rotation direction
	if input_dir.x < 0:  # Left
		rotation_direction = -1.0  # Counter-clockwise
	elif input_dir.x > 0:  # Right
		rotation_direction = 1.0  # Clockwise
	
	# Update rotation angle
	rotation_angle += rotation_direction * (orbital_speed / orbital_radius) * delta
	
	# Calculate new position based on circular motion
	var new_x = current_magnet.global_position.x + cos(rotation_angle) * orbital_radius
	var new_y = current_magnet.global_position.y + sin(rotation_angle) * orbital_radius
	var new_position = Vector2(new_x, new_y)
	
	# Store the tangent direction (perpendicular to radial direction)
	var radial_direction = (new_position - current_magnet.global_position).normalized()
	tangent_direction = Vector2(-radial_direction.y, radial_direction.x) * rotation_direction
	
	# Move player to the calculated position
	player.velocity = (new_position - player.global_position) / delta
	
	# Print debug info occasionally
	if Engine.get_frames_drawn() % 60 == 0:  # Every ~1 second at 60fps
		print("Orbiting - Angle: ", rotation_angle, ", Position: ", new_position)

# Launch the player in their current tangential direction
func launch_player(direction_multiplier: float = 1.0) -> void:
	# If we have a valid tangent direction, use it
	var launch_direction: Vector2
	
	if is_hooked and tangent_direction != Vector2.ZERO:
		# Launch in the tangent direction (direction of movement around the orbit)
		launch_direction = tangent_direction
	else:
		# Fallback: launch away from the magnet
		launch_direction = (player.global_position - current_magnet.global_position).normalized()
	
	# Apply the direction multiplier (for attraction/repulsion)
	launch_direction *= direction_multiplier
	
	# Calculate the launch velocity
	var launch_velocity = launch_direction * launch_power
	
	print("Launching player with velocity: ", launch_velocity)
	
	# Enter static velocity state with the launch velocity
	var static_state = state_machine.states.get("StaticVelocity")
	if static_state:
		static_state.set_launch_velocity(launch_velocity)
		state_machine.change_state("StaticVelocity")
	else:
		print("StaticVelocity state not found")
