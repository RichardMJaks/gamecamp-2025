extends PlayerMovementState

var static_velocity: Vector2
var launch_time: float = 0.0
var max_launch_time: float = 0.7  # Seconds to maintain static velocity
var ignore_collisions: bool = false # Whether to ignore magnet collisions during launch

func _ready() -> void:
	state_name = "StaticVelocity"

func enter() -> void:
	launch_time = 0.0
	ignore_collisions = true
	
	print("Entering StaticVelocity state with velocity: ", static_velocity)
	
	# Temporarily disable collisions with magnets to prevent immediate re-entry
	# Get the layer and mask for magnets
	var magnet_layer = 4  # Adjust this to your actual magnet layer
	
	# Store original masks
	var original_mask = player.collision_mask
	
	# Temporarily disable collisions with magnets
	player.set_collision_mask_value(magnet_layer, false)
	
	# Re-enable after a short delay
	var timer = player.get_tree().create_timer(0.2)
	timer.timeout.connect(func(): 
		player.set_collision_mask_value(magnet_layer, true)
		ignore_collisions = false
		print("Re-enabled magnet collisions")
	)

func exit() -> void:
	print("Exiting StaticVelocity state")
	
	# Reset any collision masks just in case
	var magnet_layer = 4  # Adjust to your actual magnet layer
	player.set_collision_mask_value(magnet_layer, true)
	
	# Stop the velocity when exiting
	static_velocity = Vector2.ZERO
	ignore_collisions = false

func set_launch_velocity(velocity: Vector2) -> void:
	static_velocity = velocity
	print("Set launch velocity to: ", velocity)
	
func physics_update(delta: float) -> void:
	# Increment launch time
	launch_time += delta
	
	# Apply the static velocity
	player.velocity = static_velocity
	
	# Apply a slight decay to the velocity for a more natural feel
	if launch_time > 0.2:  # Start decay after 0.2 seconds
		static_velocity *= 0.98  # Apply 2% decay per frame
	
	# Debug output
	if Engine.get_frames_drawn() % 60 == 0:  # Every ~1 second at 60fps
		print("StaticVelocity - Time: ", launch_time, ", Velocity: ", player.velocity)
	
	# Check if launch time is over or player hit something
	if launch_time >= max_launch_time or player.is_on_floor() or player.is_on_wall():
		print("Launch complete - reverting to normal movement")
		state_machine.change_state("NormalMove")
		return
	
	# During static velocity, player can still change poles
	if Input.is_action_just_pressed(&"a_switch"):
		@warning_ignore("int_as_enum_without_cast")
		player.current_pole = 1 - player.current_pole
		print("Switched pole during launch")
