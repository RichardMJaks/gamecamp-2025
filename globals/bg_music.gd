extends Node

@export var main_menu: AudioStreamPlayer
@export var in_game: AudioStreamPlayer
@export var end_screen: AudioStreamPlayer

func _process(_delta: float) -> void:
    match GameController.current_level_type:
        GameController.LEVEL_TYPE.MENU:
            if not main_menu.playing:
                main_menu.play()
            in_game.stop()
            end_screen.stop()
        GameController.LEVEL_TYPE.GAME:
            main_menu.stop()
            if not in_game.playing:
                in_game.play()
            end_screen.stop()
        GameController.LEVEL_TYPE.END:
            main_menu.stop()
            in_game.stop()
            if not end_screen.playing:
                end_screen.play()


