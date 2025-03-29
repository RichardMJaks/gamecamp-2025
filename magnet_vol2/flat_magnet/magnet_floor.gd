@tool
extends Magnet
class_name FloorMagnet

# Direction of gravity this floor magnet applies when opposite poles attract
@export_enum("Left:0", "Right:1", "Up:2", "Down:3") var magnet_direction: int = 3
var magnet_gravity_direction: Vector2i = Vector2i(0, -1):
	get:
		match(magnet_direction):
			0:
				return Vector2(1, 0)
			1:
				return Vector2(-1, 0)
			2:
				return Vector2(0, 1)
			3:
				return Vector2(0, -1)
			_:
				return Vector2(0, 0)
		  # Default is inverted gravity
@export var launch_power: float = 1200.0  # Power of the launch when polarity switches

func _ready() -> void:
	if Engine.is_editor_hint() and not get_tree().current_scene == self:
		get_parent().set_editable_instance(self, true)