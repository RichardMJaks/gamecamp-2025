@tool
extends CollisionShape2D

@export var shape_size: Vector2 = Vector2.ONE

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		shape = RectangleShape2D.new()
		shape.size = shape_size

func _process(_delta: float) -> void:
	shape_size = shape.size
