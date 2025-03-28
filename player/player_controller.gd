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

func _physics_process(delta: float) -> void:
	being_attracted = not magnets.is_empty()
	var dir = Input.get_axis(&"m_left", &"m_right")
	
	if not being_attracted and not is_on_floor():
		velocity.y += get_gravity().y * delta

	# Attraction
	if being_attracted:
		var self_pos := global_position
		for magnet: Magnet in magnets:
			var magnet_pos := magnet.global_position
			var attraction_vector = self_pos - magnet_pos
			print(attraction_vector)
			var magnet_pole: GlobalVars.POLE = magnet.pole
			var attraction_dir: int = magnet_pole * current_pole

			var magnet_strength = magnet.strength * su

			velocity += attraction_vector * attraction_dir * magnet_strength * delta

	# Movement
	if dir:
		var acceleration = speed / acceleration_time
		if abs(velocity.x) <= speed:
			velocity.x += dir * acceleration * delta
	else:
		var deceleration = speed / deceleration_time
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

	if Input.is_action_just_pressed(&"m_jump") and is_on_floor():
		velocity.y -= _get_jump_height(jump_height)

	move_and_slide()
	
	
func _get_jump_height(h: float) -> float:
	return sqrt(2 * get_gravity().y * h)
