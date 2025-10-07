extends Area2D

signal level_completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_completed.connect(GameController.complete_level)
