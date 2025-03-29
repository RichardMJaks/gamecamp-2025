extends Area2D
class_name Magnet

# Pole type (North or South)
@export var pole: GlobalVars.POLE = GlobalVars.POLE.NORTH
@export var influence_radius: float = 200.0

# Signal emitted when player enters/exits this magnet's area
signal player_entered(magnet: Magnet)
signal player_exited(magnet: Magnet)

func _ready() -> void:
	# Connect area signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player = body as Player
		player.magnets.append(self)
		emit_signal("player_entered", self)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		var player = body as Player
		player.magnets.erase(self)
		emit_signal("player_exited", self)
