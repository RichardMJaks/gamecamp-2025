extends CharacterBody2D
class_name Player

@onready var su = GlobalVars.su

var being_attracted: bool = false
var magnets: Array[Magnet] = []

@export var speed: float
@export var acceleration_time: float
@export var deceleration_time: float
@export var jump_height: float

var accel_time_delta: float = 0

var current_pole: GlobalVars.POLE = GlobalVars.POLE.NORTH

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	%Label.text = GlobalVars.POLE.find_key(current_pole)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(&"a_switch"):
		@warning_ignore("int_as_enum_without_cast")
		current_pole = current_pole * -1;

	being_attracted = not magnets.is_empty()
	
	_handle_movement(delta)

	move_and_slide()

func _handle_movement(delta) -> void:
	if Input.is_action_just_pressed(&"m_jump") and is_on_floor():
		velocity.y -= _get_jump_height(jump_height)

	var dir = Input.get_vector(&"m_left", &"m_right", &"m_up", &"m_down")
	var acceleration = speed / acceleration_time
	var deceleration = speed / deceleration_time

	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	if not dir and not being_attracted:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		return

	if dir and abs(velocity.x) < speed:
		velocity.x += dir.x * acceleration * delta

	if not being_attracted and is_on_floor():
		velocity.x = min(abs(velocity.x), abs(speed)) * sign(velocity.x)

	
	
func _get_jump_height(h: float) -> float:
	return sqrt(2 * get_gravity().y * h)
