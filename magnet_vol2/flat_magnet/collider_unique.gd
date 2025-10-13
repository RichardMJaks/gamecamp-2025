@tool
extends CollisionShape2D

@export var shape_size: Vector2 = Vector2.ONE * 16

#func _enter_tree() -> void:
	#if Engine.is_editor_hint():
		#shape = RectangleShape2D.new()
		#shape.size = shape_size

func _ready() -> void:
	if Engine.is_editor_hint():
		get_parent().pole_changed.connect(_match_debug_color)

func _process(_delta: float) -> void:
	shape_size = shape.size


func _match_debug_color(pole: GlobalVars.POLE) -> void:
	match(pole):
		GlobalVars.POLE.SOUTH:
			debug_color = Color8(255, 39, 59, 107)
		GlobalVars.POLE.NORTH:
			debug_color = Color8(0, 153, 179, 107)
