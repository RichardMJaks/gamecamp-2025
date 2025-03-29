extends Magnet
class_name RadialMagnet

@export_enum("Left:1", "Right:-1") var rotation_direction: int = 1
@onready var particles: Node2D = $RadialParticles
@onready var magnet_area: CollisionShape2D = $MagnetArea
