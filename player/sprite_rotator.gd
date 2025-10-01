extends AnimatedSprite2D

#TODO: Match player hitbox with sprite dimensions (rotate the whole hitbox?)
@onready var player: Player = owner
@onready var current_rotation = player.up_direction
@export var rotation_speed = 0.3
var rotation_interpolation_delta: float = 0:
	get:
		return min(rotation_interpolation_delta, 1)
@export var sprite: AnimatedSprite2D

#FIXME: Player rotation should be opposite if in the same pole range
func _process(delta):
	#FIXME: What is this mess for rotations here? Magic numbers n shit without explanation
	if player.current_magnet:
		if current_rotation != player.up_direction.rotated(PI/2) and player.current_magnet.pole != player.current_pole:
			rotation_interpolation_delta = 0
			current_rotation = player.up_direction.rotated(PI/2)
		if current_rotation != -player.up_direction.rotated(PI/2) and player.current_magnet.pole == player.current_pole:
			rotation_interpolation_delta = 0
			current_rotation = -player.up_direction.rotated(PI/2)
	else:
		if current_rotation != Vector2.ZERO:
			rotation_interpolation_delta = 0
			current_rotation = Vector2.ZERO
	
	if player.current_magnet and player.current_magnet is RadialMagnet:
		#FIXME: Seems like radial magnet state sets player.up_direction for rotation
		rotation = player.up_direction.angle() + PI/2
		flip_h = player.current_magnet.rotation_direction == -1

	if rotation_interpolation_delta <= 1:
		rotation = rotate_toward(rotation, current_rotation.angle(), rotation_interpolation_delta)
		rotation_interpolation_delta += delta / rotation_speed
	_flip_sprite_to_movement_direction()

#HACK: Are you sure there is no better way to do it?
func _flip_sprite_to_movement_direction() -> void:
	match(player.up_direction):
		Vector2.UP:
			if player.velocity.x > 0:
				flip_h = false
			if player.velocity.x < 0:
				flip_h = true
		Vector2.LEFT:
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