extends Magnet
class_name RadialMagnet

@export_enum("Left:1", "Right:-1") var rotation_direction: int = 1
@export var radius: float = 16
@onready var particles: Node2D = $RadialParticles
@onready var magnet_area: CollisionShape2D = $MagnetArea

func _ready() -> void:
	if Engine.is_editor_hint():
		particles = $RadialParticles
		magnet_area = $MagnetArea
		magnet_area.shape = magnet_area.shape.duplicate()
		radius = radius # Used to trigger its set
		rotation_direction = rotation_direction
