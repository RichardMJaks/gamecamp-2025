extends Node

@export var next_level: PackedScene

func _on_level_end_area_body_entered(body):
	if body is Player:
		_on_level_complete()

func _on_level_complete():
	GameController.complete_level()
