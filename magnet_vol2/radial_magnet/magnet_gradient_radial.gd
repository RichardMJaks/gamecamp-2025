@tool
extends Sprite2D

@export var collider: CollisionShape2D

@export var north_gradient: Gradient
@export var south_gradient: Gradient


func _ready() -> void:
	texture = GradientTexture2D.new()
	texture.fill = GradientTexture2D.FILL_RADIAL

func _process(_delta: float) -> void:
	# To not fill console up with errors
	if not collider:
		return

	position = collider.position
	_apply_colors()
	_apply_size()
	

func _apply_colors() -> void:
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(0.5, 0)
	if owner.pole == GlobalVars.POLE.NORTH:
		texture.gradient = north_gradient
	if owner.pole == GlobalVars.POLE.SOUTH:
		texture.gradient = south_gradient

func _apply_size() -> void:
	var texture_size = collider.shape.radius
	texture.width = texture_size * 2
	texture.height = texture_size * 2
