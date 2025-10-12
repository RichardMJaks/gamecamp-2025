extends CanvasLayer
class_name UI

@onready var collectibles_label : Label = %CollectibleCounter
@onready var timer_label : Label = %LevelTimer
@onready var fader: Fader = %Fader
@onready var level_complete: PanelContainer = %LevelCompleteContainer

signal fade_in_finished
signal fade_out_finished


func _process(delta: float) -> void:
	pass


func show_level_end_screen(level_data: LevelData) -> void:
	level_complete.show_ui(level_data.collectibles_collected, level_data.time_spent)

func _on_fade_out_finished() -> void:
	SignalBus.fade_out_completed.emit()

func _on_fade_in_finished() -> void:
	SignalBus.fade_in_completed.emit()