@tool
extends Sprite2D

@export var collider: CollisionShape2D
var positions: Array[Array] = [
	[Vector2.ZERO, Vector2(1, 0)],
	[Vector2(1, 0), Vector2.ZERO],
	[Vector2.ZERO, Vector2(0, 1)],
	[Vector2(0, 1), Vector2.ZERO]
]

@export var north_gradient: Gradient
@export var south_gradient: Gradient

func _ready() -> void:
	texture = GradientTexture2D.new()

func _process(_delta: float) -> void:
	# To not fill console up with errors
	if not collider:
		return

	position = collider.position
	_apply_colors()
	_apply_size()
	

func _apply_colors() -> void:
	var gradient_positions = positions[get_parent().magnet_direction]
	texture.fill_from = gradient_positions[0]
	texture.fill_to = gradient_positions[1]
	if get_parent().pole == GlobalVars.POLE.NORTH:
		texture.gradient = north_gradient
	if get_parent().pole == GlobalVars.POLE.SOUTH:
		texture.gradient = south_gradient

func _apply_size() -> void:
	var texture_size = collider.shape.size
	texture.width = texture_size.x
	texture.height = texture_size.y
