extends Magnet
class_name FloorMagnet

# Direction of gravity this floor magnet applies when opposite poles attract
@export var magnet_gravity_direction: Vector2i = Vector2i(0, -1)  # Default is inverted gravity
@export var launch_power: float = 800.0  # Power of the launch when polarity switches

var affected_players: Array[Player] = []
var original_gravity_directions: Dictionary = {}  # Store original gravity directions for players

func _ready() -> void:
	super._ready()

func _process(_delta: float) -> void:
	# For each affected player, check if polarity has changed
	for player in affected_players:
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
			player.gravity_direction = original_gravity_directions[player]

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player = body as Player
		
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
		
		# Restore original gravity direction
		if original_gravity_directions.has(player):
			player.gravity_direction = original_gravity_directions[player]
			original_gravity_directions.erase(player)
			print("Restoring gravity to: ", player.gravity_direction)
		
		# Remove from affected players array
		affected_players.erase(player)
		
		# Remove from magnets array (parent class functionality)
		super._on_body_exited(body)

func launch_player(player: Player) -> void:
	# Launch in the direction of the reversed gravity
	var launch_direction = -player.gravity_direction
	var launch_velocity = launch_direction * launch_power
	
	# Use the StaticVelocity state to launch the player
	var state_machine = player.get_node("MovementStateMachine")
	if state_machine:
		var static_state = state_machine.states.get("StaticVelocity")
		if static_state:
			static_state.set_launch_velocity(launch_velocity)
			state_machine.change_state("StaticVelocity")
			print("Launching player with velocity: ", launch_velocity)
