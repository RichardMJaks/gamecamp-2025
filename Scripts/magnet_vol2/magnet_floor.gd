extends Magnet
class_name FloorMagnet

# Direction of gravity this floor magnet applies when opposite poles attract
@export var magnet_gravity_direction: Vector2i = Vector2i(0, -1)  # Default is inverted gravity
@export var launch_power: float = 1200.0  # Power of the launch when polarity switches
