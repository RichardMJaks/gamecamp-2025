extends Control

@export var first_level: PackedScene
func _ready() -> void:
	BgMusic.play_music(BgMusic.MusicType.MENU)

func _play_pressed() -> void:
	get_tree().change_scene_to_packed(first_level)
