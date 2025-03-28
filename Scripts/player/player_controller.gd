extends CharacterBody2D
class_name Player

# Define the signal for state changes
signal movement_state_changed(state_name: String)

@onready var su = GlobalVars.su
@onready var state_machine = $MovementStateMachine
@onready var gravity_component = $GravityComponent

var being_attracted: bool = false
var magnets: Array[Magnet] = []

@export var speed: float = 300.0
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

var accel_time_delta: float = 0
var current_pole: GlobalVars.POLE = GlobalVars.POLE.NORTH

func _ready() -> void:
	# Ensure state machine is initialized
	if state_machine == null:
		state_machine = $MovementStateMachine
		if state_machine == null:
			push_error("MovementStateMachine not found in Player!")
	
	# Debug message to confirm state machine is found
	if state_machine:
		print("State Machine found: ", state_machine.name)

func _process(_delta: float) -> void:
	if has_node("%Label"):
		%Label.text = GlobalVars.POLE.find_key(current_pole)
	
	# Debug pole switching
	if Input.is_action_just_pressed(&"a_switch"):
		@warning_ignore("int_as_enum_without_cast")
		current_pole = 1 - current_pole
		print("Switched pole to: ", GlobalVars.POLE.find_key(current_pole))

func _physics_process(delta: float) -> void:
	# Let the state machine handle movement logic
	if state_machine and state_machine.current_state:
		# Debug info
		if Engine.is_editor_hint() or OS.is_debug_build():
			print("Current state: ", state_machine.current_state.state_name)
	else:
		# Fallback to basic movement if state machine isn't working
		handle_basic_movement(delta)
	
	# Apply movement
	move_and_slide()

# Fallback movement in case state machine isn't working
func handle_basic_movement(delta: float) -> void:
	# Simple horizontal movement
	var direction = Input.get_axis("m_left", "m_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Let the gravity component handle gravity if available
	if gravity_component == null:
		# Apply gravity manually if no component
		if not is_on_floor():
			velocity.y += get_gravity().y * delta
	
	# Handle jump
	if Input.is_action_just_pressed("m_jump") and is_on_floor():
		velocity.y = -sqrt(2 * get_gravity().y * jump_height)

func _get_jump_height(h: float) -> float:
	return sqrt(2 * get_gravity().y * h)
