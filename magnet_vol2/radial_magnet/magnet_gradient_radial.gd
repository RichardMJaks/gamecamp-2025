@tool
extends Sprite2D

@export var collider: CollisionShape2D

@export var north_gradient: Gradient
@export var south_gradient: Gradient
@export var north_area: Texture2D
@export var south_area: Texture2D

@onready var magnet_area: CollisionShape2D = %MagnetArea


func _ready() -> void:
	texture = GradientTexture2D.new()
	texture.fill = GradientTexture2D.FILL_RADIAL

func _process(_delta: float) -> void:
	# To not fill console up with errors
	if not collider:
		return

	position = collider.position
	_apply_colors()
	

func _apply_colors() -> void:
	if get_parent().pole == GlobalVars.POLE.NORTH:
		texture = north_area
		magnet_area.debug_color = Color8(0, 153, 179, 107)
	if get_parent().pole == GlobalVars.POLE.SOUTH:
		magnet_area.debug_color = Color8(255, 39, 59, 107)
		texture = south_area
