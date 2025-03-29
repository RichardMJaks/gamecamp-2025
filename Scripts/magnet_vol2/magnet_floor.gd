extends Magnet
class_name FloorMagnet

# Direction of gravity this floor magnet applies when opposite poles attract
@export var magnet_gravity_direction: Vector2i = Vector2i(0, -1)  # Default is inverted gravity
@export var launch_power: float = 1200.0  # Power of the launch when polarity switches


func _ready() -> void:
	super._ready()

func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

func _on_body_exited(body: Node2D) -> void:
	if not body is Player:
		return	

	# Guard clause to prevent edge case bugs	
	if not body.current_magnet == self:
		return
