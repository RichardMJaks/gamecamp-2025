extends Area2D

var speed = 200
var velocity = Vector2.ZERO

func _on_body_entered(body):
	print("Touched body: ", body.name)

func _on_area_entered(area):
	print("Entered area: ", area.name)
	
func _ready():
	position = Vector2(100, 100)
	self.collision_layer = 2
	#self.collision_mask = ...  
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 10  # Adjust to match player size
	collision_shape.shape = shape
	add_child(collision_shape)
	
	connect("body_entered", _on_body_entered)
	connect("area_entered", _on_area_entered)

func _process(_delta: float) -> void:
	pass

func _draw():
	draw_circle(Vector2.ZERO, 10, Color.PURPLE)

func _physics_process(delta):
	# Handle movement input
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	# Normalize diagonal movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	# Move the player (Area2D doesn't have move_and_slide)
	position += velocity * delta
