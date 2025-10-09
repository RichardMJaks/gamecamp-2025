extends Area2D

signal level_completed
var player: Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_completed.connect(GameController.complete_level)


func _on_player_entered_end_gate(body: Player) -> void:
	var end_position = _get_player_end_position()
	_tween_player_to_end_position(body, end_position)

func _tween_player_to_end_position(player: Player, end_position: Vector2) -> void:
	var tween = player.create_tween()
	tween.tween_property(player, ^"global_position", end_position, 0.1) 


func _get_player_end_position() -> Vector2:
	return $PlayerFinalPosition.global_position

