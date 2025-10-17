extends Node

enum MusicType {MENU, INGAME, END}

@export var main_menu: AudioStreamPlayer
@export var in_game: AudioStreamPlayer
@export var end_screen: AudioStreamPlayer

var current_player: AudioStreamPlayer = null

@onready var music_players: Array[AudioStreamPlayer] = [
	main_menu,
	in_game,
	end_screen,
]


func play_music(music_type: MusicType) -> void:
	for i in range(music_players.size()):
		if i != music_type:
			music_players[i].stop()
		else:
			if not music_players[i].playing:
				current_player = music_players[i]
				current_player.play()
				current_player.volume_db = -5

func fade_music_out() -> void:
	if not current_player:
		return
	
	var fade_tweener: Tween = current_player.create_tween()
	fade_tweener.tween_property(current_player, ^"volume_linear", 0, 0.5)

func _fader(value: float) -> void:
	if not current_player:
		return 
	
	current_player.volume_linear = value
