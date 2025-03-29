extends AnimatedSprite2D

@onready var player: Player = owner
@onready var current_rotation = player.up_direction
@export var rotation_speed = 0.3
var rotation_step: float = 0:
	get:
		return min(rotation_step, 1)
@export var sprite: AnimatedSprite2D

func _process(delta):
	if player.current_magnet:
		if current_rotation != player.up_direction.rotated(PI/2) and player.current_magnet.pole != player.current_pole:
			rotation_step = 0
			current_rotation = player.up_direction.rotated(PI/2)
	else:
		if current_rotation != Vector2.ZERO:
			rotation_step = 0
			current_rotation = Vector2.ZERO
	
	if player.current_magnet and player.current_magnet is RadialMagnet:
		rotation = player.up_direction.angle() + PI

	if rotation_step <= 1:
		rotation = rotate_toward(rotation, current_rotation.angle(), rotation_step)
		rotation_step += delta / rotation_speed

	print(player.up_direction)	
	match(player.up_direction):
		Vector2.UP:
			if player.velocity.x > 0:
				flip_h = false
			if player.velocity.x < 0:
				flip_h = true
		Vector2.LEFT:
			print("up")
			if player.velocity.y < 0:
				flip_h = false
			if player.velocity.y > 0:
				flip_h = true
		Vector2.RIGHT:
			if player.velocity.y > 0:
				flip_h = false
			if player.velocity.y < 0:
				flip_h = true
		Vector2.DOWN:
			if player.velocity.x < 0:
				flip_h = false
			if player.velocity.x > 0:
				flip_h = true
