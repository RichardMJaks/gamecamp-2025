extends PlayerMovementState

func _ready() -> void:
	state_name = "NormalMove"

func enter() -> void:
	# Reset any specific properties when entering normal movement
	player.gravity_direction = Vector2i(0, 1)

func exit() -> void:
	# Clean up or save state if needed
	pass

func physics_update(delta: float) -> void:
	# Print debug information
	print("NormalMove physics_update")
	
	# Apply gravity
	apply_gravity(delta)
	
	# Handle jump
	handle_jump()
	
	# Get input direction
	var dir: Vector2i = Input.get_vector(&"m_left", &"m_right", &"m_up", &"m_down")
	print("Input direction: ", dir)
	
	# Calculate acceleration and deceleration
	var acceleration: float = player.speed * player.su / player.acceleration_time
	var deceleration: float = player.speed * player.su / player.deceleration_time
	
	# Apply horizontal movement
	if dir.x and abs(player.velocity.x) < player.speed:
		player.velocity.x += dir.x * acceleration * delta
		print("Applied horizontal acceleration: ", dir.x * acceleration * delta)
	
	# Apply deceleration when no input or changing direction
	if (dir.x == 0 or sign(dir.x) != sign(player.velocity.x)):
		player.velocity.x = move_toward(player.velocity.x, 0, deceleration * delta)
		print("Applied deceleration")
	
	# Update player's up direction based on gravity
	player.up_direction = -player.gravity_direction
	
	# Print final velocity
	print("Final velocity: ", player.velocity)
