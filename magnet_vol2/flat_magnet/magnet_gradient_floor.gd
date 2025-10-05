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

@export var outlines: Array[Sprite2D] = [

]

@export var outline_thickness: int = 1

func _ready() -> void:
	set_editable_instance(self, true)
	texture = GradientTexture2D.new()

func _process(_delta: float) -> void:
	# To not fill console up with errors
	if not collider:
		return

	position = collider.position
	#_apply_colors()
	#_apply_size()
	
# Deprecated function, will be handled by a tilemaplayer
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

	for outline in outlines:
		outline.texture.gradient = outline_color
		outline.texture.height = outline_thickness

# Deprecated function, will be handled by a tilemaplayer
func _apply_size() -> void:
	var texture_size = collider.shape.size
	texture.width = texture_size.x
	texture.height = texture_size.y

	outlines[0].texture.width = texture_size.x
	outlines[0].position.y = -texture_size.y / 2 - outlines[0].texture.height / 2

	outlines[1].texture.width = texture_size.x
	outlines[1].position.y = texture_size.y / 2 + outlines[1].texture.height / 2

	outlines[2].texture.width = texture_size.y
	outlines[2].position.x = -texture_size.x / 2 - outlines[2].texture.height / 2

	outlines[3].texture.width = texture_size.y
	outlines[3].position.x = texture_size.x / 2 + outlines[3].texture.height / 2
