extends CharacterBody2D

var player_color = Color.RED
var player_charge = 1.0
var speed = 200
var acceleration = 5000 * 5
var max_speed = 150
var gravity = 980 * 30
var jump_force = -4400 * 3
var air_resistance = 0.02
var floor_friction = 0.2
var field_constant = 2500000 * 1.3
var fields: Dictionary
var field_applying = Vector2(0, 0)

func _ready():
	position = Vector2(0, 0)
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 10
	collision_shape.shape = shape
	add_child(collision_shape)
	
	#motion_mode = MOTION_MODE_FLOATING
	collision_layer = 1
	collision_mask = 1

func enter_ff(ff):
	fields[ff] = true
	print("player entered ff at:", ff.shape.position)

func exit_ff(ff):
	fields.erase(ff)
	print("player exitted ff at:", ff.shape.position)

func get_field_force():
	var final_force = Vector2(0, 0)
	for field in fields:
		final_force += position.direction_to(field.shape.position) * (field_constant * field.strength / (position.distance_to(field.shape.position) ** 2)) * player_charge
	return final_force

func _physics_process(delta: float):
	var force = get_field_force()
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


	if is_on_wall():
		var ang = get_wall_normal().angle_to(force)
		print(ang, force)
		if ang < 5.0 and ang > -5.0 and force:
			if abs(velocity.y) < max_speed / 2:
				force.y += input.y * acceleration * delta * 5

	if abs(velocity.x) < max_speed:
		var xmove = input.x * acceleration * delta
		if not (is_on_floor()):
			if is_on_ceiling():
				xmove *= 10
			else:
				xmove *= 0.2	
		force.x += xmove

	force.y += gravity * delta
	velocity += force * delta

	if is_on_floor(): # friction
		if input.x == 0:
			velocity.x = lerp(velocity.x, 0.0, floor_friction)
	else:
		velocity.x = lerp(velocity.x, 0.0, air_resistance)
	
	move_and_slide()

func _input(event):
	if event.is_action_pressed("ui_select"):
		player_charge = player_charge * -1.0
		self.player_color = Color.BLUE
	
func _draw():
	draw_circle(Vector2.ZERO, 10, self.player_color, true, -1, true)
	
	#for f in fields:
		#draw_line(position, f.shape.position, Color.BLACK, 2, true)
