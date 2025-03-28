extends PlayerMovementState

var static_velocity: Vector2
var launch_time: float = 0.0
var max_launch_time: float = 0.7  # Seconds to maintain static velocity

func _ready() -> void:
	state_name = "StaticVelocity"

func enter() -> void:
	launch_time = 0.0
	
	# Disable player collision mask with magnets (optional)
	# This prevents immediate re-entry into magnets during launch
	# var collision_layer = player.collision_layer
	# player.set_collision_mask_value(YOUR_MAGNET_LAYER, false)

func exit() -> void:
	# Reset any collision masks if you changed them
	# player.set_collision_mask_value(YOUR_MAGNET_LAYER, true)
	
	# Stop the velocity when exiting
	static_velocity = Vector2.ZERO

func set_launch_velocity(velocity: Vector2) -> void:
	static_velocity = velocity
	
func physics_update(delta: float) -> void:
	# Increment launch time
	launch_time += delta
	
	# Apply the static velocity
	player.velocity = static_velocity
	
	# Check if launch time is over or player hit something
	if launch_time >= max_launch_time or player.is_on_floor() or player.is_on_wall():
		state_machine.change_state("NormalMove")
		return
	
	# During static velocity, player can still change poles
	if Input.is_action_just_pressed(&"a_switch"):
		@warning_ignore("int_as_enum_without_cast")
		player.current_pole = 1 - player.current_pole
	
	# Check if player is trying to hook to a radial magnet
	# (This will be handled through the radial magnet's body_entered signal)
