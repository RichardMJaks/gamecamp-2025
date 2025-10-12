extends Node

@export var main_menu: AudioStreamPlayer
@export var in_game: AudioStreamPlayer
@export var end_screen: AudioStreamPlayer

enum MusicType {MENU, INGAME, END}
var music_players: Array[AudioStreamPlayer] = [
	main_menu,
	in_game,
	end_screen,
]


func play_music(music_type: MusicType) -> void:
	for i in range(music_players.size()):
		if i != music_type:
			music_players[i].stop()
		else:
			music_players[i].play()
