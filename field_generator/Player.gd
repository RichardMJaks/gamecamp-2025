extends CharacterBody2D

var speed = 200
var acceleration = 5000 * 3
var max_speed = 150
var gravity = 980 * 10
var jump_force = -4400 * 2
var air_resistance = 0.02
var floor_friction = 0.2
var magnet_modifier = 500
var fields: Dictionary
var field_applying = Vector2(0, 0)


func _ready():
	position = Vector2(0, 0)
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 10
	collision_shape.shape = shape
	add_child(collision_shape)
	
	collision_layer = 1
	collision_mask = 1

func enter_ff(force: Vector2):
	if not force in fields:
		fields[force] = 1
	else:
		fields[force] += 1
	field_applying = force
	print("entered: ", force)
	print("fields are now: ", fields)
	
func exit_ff(force: Vector2):
	if not force in fields:
		return
	var num = fields[force]
	if num == 1:
		fields.erase(force)
		if len(fields) == 0:
			field_applying = Vector2(0, 0)
		else:
			for f in fields: # select some different field
				field_applying = f
				break
	else:
		fields[force] -= 1
	print("exitted: ", force)
	print("fields are now: ", fields)

func _physics_process(delta: float):
	var force = field_applying * magnet_modifier
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if abs(velocity.x) < max_speed:
		force.x += input.x * acceleration * delta
	if input.y < 0 and is_on_floor():
		force.y = jump_force

	force.y += gravity * delta
	velocity += force * delta

	if is_on_floor():
		if input.x == 0:
			velocity.x = lerp(velocity.x, 0.0, floor_friction)
	else:
		velocity.x = lerp(velocity.x, 0.0, air_resistance)
	
	move_and_slide()
	
	force = Vector2.ZERO
	
func _draw():
	draw_circle(Vector2.ZERO, 10, Color.PURPLE)
