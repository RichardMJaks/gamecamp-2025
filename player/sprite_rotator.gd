extends AnimatedSprite2D

#TODO: Match player hitbox with sprite dimensions (rotate the whole hitbox?)
@onready var player: Player = owner
@onready var target_rotation = player.up_direction
@export var rotation_speed = 0.3
var rotation_interpolation_delta: float = 0:
	get:
		return min(rotation_interpolation_delta, 1)
@export var sprite: AnimatedSprite2D
var error_pushed: bool = false

#FIXME: Player rotation should be opposite if in the same pole range
func _process(delta):
	_handle_rotation_states(delta)	
	_flip_sprite_to_movement_direction()


func _rotate_sprite(delta) -> void:
	if rotation_interpolation_delta <= 1:
		rotation = rotate_toward(rotation, target_rotation.angle(), rotation_interpolation_delta)
		rotation_interpolation_delta += delta / rotation_speed


func _handle_rotation_states(delta: float) -> void:
	var current_magnet = player.current_magnet
	if not current_magnet:
		_handle_normal_state_rotation()
		_rotate_sprite(delta)
		return

	if current_magnet is RadialMagnet:
		_handle_radial_magnet_state_rotation()
		return
	
	_handle_floor_magnet_state_rotation()
	_rotate_sprite(delta)


func _handle_normal_state_rotation() -> void:
	if target_rotation != Vector2.ZERO:
		rotation_interpolation_delta = 0
		target_rotation = Vector2.ZERO


func _handle_floor_magnet_state_rotation() -> void:
	var expected_target_rotation = player.up_direction.rotated(PI/2) # up_direction is -90d off from actual rotation
	var magnet_pole = player.current_magnet.pole
	var player_pole = player.current_pole
	var pole_matches = magnet_pole == player_pole

	if not pole_matches and target_rotation != expected_target_rotation:
		rotation_interpolation_delta = 0
		target_rotation = expected_target_rotation
	if pole_matches and target_rotation != expected_target_rotation:
		rotation_interpolation_delta = 0
		target_rotation = expected_target_rotation
	

func _handle_radial_magnet_state_rotation() -> void:
	var vector_from_magnet = player.global_position - player.current_magnet.global_position 
	rotation = vector_from_magnet.angle() + PI/2
	flip_h = player.current_magnet.rotation_direction == -1


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
