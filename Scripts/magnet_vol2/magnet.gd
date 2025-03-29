extends Area2D
class_name Magnet

# Pole type (North or South)
@export var pole: GlobalVars.POLE = GlobalVars.POLE.NORTH
@export var influence_radius: float = 200.0


func _ready() -> void:
	# Connect area signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	body = body as Player
	body.current_magnet = self

func _on_body_exited(body: Node2D) -> void:
	if not body is Player:
		return	

	# Guard clause to prevent edge case bugs	
	if not body.current_magnet == self:
		return
