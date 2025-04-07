extends Control

@export var loading_screen: PackedScene
func _ready() -> void:
	GameController.current_level_type = GameController.LEVEL_TYPE.MENU
func _play_pressed() -> void:
	get_tree().change_scene_to_packed(loading_screen)