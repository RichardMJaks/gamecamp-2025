extends CollisionShape2D

func _ready() -> void:
	shape = RectangleShape2D.new()
	shape.size = Vector2.ONE * GlobalVars.su
