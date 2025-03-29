extends Node
class_name PlayerMovementStateMachine

# References
@export var player: Player

# States
var states: Dictionary = {}
var current_state: PlayerMovementState
var previous_state: PlayerMovementState

func _ready() -> void:
	# Get reference to player if not set through export
	if player == null:
		player = get_parent() as Player
		print("Auto-detected player: ", player)
	
	# Initialize states by getting all child nodes that are PlayerMovementState
	for child in get_children():
		if child is PlayerMovementState:
			states[child.state_name] = child
			child.player = player
			child.state_machine = self
			print("Registered state: ", child.state_name)
	
	# Debug output of available states
	print("Available states: ", states.keys())
	
	# Set initial state
	if states.has("NormalMove"):
		print("Setting initial state to NormalMove")
		change_state("NormalMove")
	else:
		push_error("NormalMove state not found!")
		print("Available states: ", states.keys())
		
	# Connect to the movement_state_changed signal from player, but only if player is valid
	if player != null:
		# Check if signal exists first
		if player.has_signal("movement_state_changed"):
			player.connect("movement_state_changed", _on_movement_state_changed)
			print("Connected to movement_state_changed signal")
		else:
			push_error("Player does not have movement_state_changed signal")

func _on_movement_state_changed(state_name: String) -> void:
	print("Player changed to state: ", state_name)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(state_name: String) -> void:
	if not states.has(state_name):
		push_error("State " + state_name + " doesn't exist!")
		return
	
	if current_state:
		current_state.exit()
		previous_state = current_state
	
	current_state = states[state_name]
	current_state.enter()
	
	# Optional: Signal that state has changed
	player.emit_signal("movement_state_changed", state_name)

func return_to_previous_state() -> void:
	if previous_state:
		change_state(previous_state.state_name)
