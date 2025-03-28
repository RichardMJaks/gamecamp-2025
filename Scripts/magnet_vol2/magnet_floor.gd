extends Magnet
class_name FloorMagnet

# Direction of gravity this floor magnet applies when opposite poles attract
@export var magnet_gravity_direction: Vector2i = Vector2i(0, -1)  # Default is inverted gravity
@export var launch_power: float = 1200.0  # Power of the launch when polarity switches

var affected_players: Array[Player] = []
var original_gravity_directions: Dictionary = {}  # Store original gravity directions for players
var launching_players: Dictionary = {}  # Track players that are being launched

func _ready() -> void:
	super._ready()

func _process(_delta: float) -> void:
	# For each affected player, check if polarity has changed
	for player in affected_players.duplicate():  # Use duplicate to safely modify during iteration
		# Skip players that are currently being launched
		if launching_players.has(player):
			continue
			
		var polarity_match = (player.current_pole != pole)  # Opposite poles attract
		
		# Update gravity direction based on current polarity
		if polarity_match:
			# Attraction - Reverse gravity 
			player.gravity_direction = magnet_gravity_direction
		else:
			# Repulsion - Normal gravity (or launch if it was previously attracted)
			if player.gravity_direction == magnet_gravity_direction:
				# If we were previously attracted and now repelled, launch
				launch_player(player)
			else:
				player.gravity_direction = original_gravity_directions[player]

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player = body as Player
		
		# If this player is currently being launched, ignore re-entry
		if launching_players.has(player):
			print("Player is being launched, ignoring re-entry")
			return
		
		# Store the original gravity direction
		original_gravity_directions[player] = player.gravity_direction
		
		# Add to affected players array 
		affected_players.append(player)
		
		# Add to magnets array (parent class functionality)
		super._on_body_entered(body)
		
		# Check if poles are opposite (attraction)
		var polarity_match = (player.current_pole != pole)
		if polarity_match:
			# Reverse gravity direction
			player.gravity_direction = magnet_gravity_direction
			print("Floor magnet changing gravity to: ", magnet_gravity_direction)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		var player = body as Player
		
		# If this player is being launched, mark as completed launch
		if launching_players.has(player):
			launching_players.erase(player)
			print("Player successfully exited magnet area after launch")
		
		# Restore original gravity direction
		if original_gravity_directions.has(player):
			player.gravity_direction = original_gravity_directions[player]
			original_gravity_directions.erase(player)
			print("Restoring gravity to: ", player.gravity_direction)
		
		# Remove from affected players array
		affected_players.erase(player)
		
		# Remove from magnets array (parent class functionality)
		super._on_body_exited(body)
		
func _on_launch_timeout(player: Player) -> void:
	# Safety cleanup in case the player didn't properly exit the area
	if launching_players.has(player):
		print("Launch timeout - cleaning up player state")
		launching_players.erase(player)
		affected_players.erase(player)
		
		# Restore original gravity if still needed
		if original_gravity_directions.has(player):
			player.gravity_direction = original_gravity_directions[player]
			original_gravity_directions.erase(player)

func launch_player(player: Player) -> void:
	# Mark this player as being launched to prevent re-entry processing
	launching_players[player] = true
	
	# Launch in the direction of the reversed gravity
	var launch_direction = -player.gravity_direction
	var launch_velocity = launch_direction * launch_power
	
	# Immediately remove from affected players to prevent interference
	affected_players.erase(player)
	
	# Restore original gravity before launching
	player.gravity_direction = original_gravity_directions[player]
	
	# Use the StaticVelocity state to launch the player
	var state_machine = player.get_node("MovementStateMachine")
	if state_machine:
		var static_state = state_machine.states.get("StaticVelocity")
		if static_state:
			# Set a longer launch time to ensure player exits the area
			static_state.max_launch_time = 1.0  # Increase from default 0.7
			static_state.set_launch_velocity(launch_velocity)
			state_machine.change_state("StaticVelocity")
			print("Launching player with velocity: ", launch_velocity)
			
			# Schedule to clean up the launching state if body_exited doesn't get called
			var timer = get_tree().create_timer(1.5)
			timer.timeout.connect(_on_launch_timeout.bind(player))
