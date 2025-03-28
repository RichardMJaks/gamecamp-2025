extends CharacterBody2D
class_name Player

@onready var su = GlobalVars.su

var being_attracted: bool = false
var magnets: Array[Magnet] = []

@export var speed: float
@export var acceleration_time: float
@export var deceleration_time: float
@export var jump_height: float
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
	pass

func _process(_delta: float) -> void:
	%Label.text = GlobalVars.POLE.find_key(current_pole)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(&"a_switch"):
		@warning_ignore("int_as_enum_without_cast")
		current_pole = 1 - current_pole;

	being_attracted = not magnets.is_empty()
	
	_handle_movement(delta)

	move_and_slide()

func _handle_movement(delta) -> void:
	up_direction = -gravity_direction
	var dir: Vector2i = Input.get_vector(&"m_left", &"m_right", &"m_up", &"m_down")
	var acceleration: float = speed * su / acceleration_time
	var deceleration: float = speed * su / deceleration_time

	print(gravity_direction)
	if gravity_direction.x == 0:
		if Input.is_action_just_pressed(&"m_jump") and is_on_floor():
			velocity.y -= _get_jump_height(jump_height) * gravity_direction.y

		if not is_on_floor():
			velocity.y += get_gravity().y * delta * gravity_direction.y

		if dir.x and abs(velocity.x) < speed:
			velocity.x += dir.x * acceleration * delta 

		if (dir.x == 0 or sign(dir.x) != sign(velocity.x)): 
			velocity.x = move_toward(velocity.x, 0, deceleration * delta)
			return
	else:
		if Input.is_action_just_pressed(&"m_jump") and is_on_floor():
			velocity.x -= _get_jump_height(jump_height) * gravity_direction.x


		if not is_on_floor():
			velocity.x += get_gravity().y * delta 

		if dir.y and abs(velocity.y) < speed:
			velocity.y += dir.y * acceleration * delta 

		if (dir.y == 0 or sign(dir.y) != sign(velocity.y)): 
			velocity.y = move_toward(velocity.y, 0, deceleration * delta)
			return



	
	
func _get_jump_height(h: float) -> float:
	return sqrt(2 * get_gravity().y * h)
