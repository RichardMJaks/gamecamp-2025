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
@export var north_outline: Gradient
@export var south_outline: Gradient

@export var outline_thickness: int = 1

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
	var outline_color = null 
	if get_parent().pole == GlobalVars.POLE.NORTH:
		texture.gradient = north_gradient
		outline_color = north_outline
	if get_parent().pole == GlobalVars.POLE.SOUTH:
		texture.gradient = south_gradient
		outline_color = south_outline

	var outlines = [
		%OutlineTop,
		%OutlineBottom,
		%OutlineLeft,
		%OutlineRight
	]

	for outline in outlines:
		outline.texture.gradient = outline_color
		outline.texture.height = outline_thickness


func _apply_size() -> void:
	var texture_size = collider.shape.size
	texture.width = texture_size.x
	texture.height = texture_size.y

	%OutlineTop.texture.width = texture_size.x
	%OutlineTop.position.y = -texture_size.y / 2 + %OutlineTop.texture.height / 2

	%OutlineBottom.texture.width = texture_size.x
	%OutlineBottom.position.y = texture_size.y / 2 - %OutlineBottom.texture.height / 2 

	%OutlineLeft.texture.width = texture_size.y
	%OutlineLeft.position.x = -texture_size.x / 2 + %OutlineLeft.texture.height / 2

	%OutlineRight.texture.width = texture_size.y
	%OutlineRight.position.x = texture_size.x / 2 - %OutlineRight.texture.height / 2
