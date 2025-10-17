extends CanvasLayer
class_name UI

@onready var collectibles_label : Label = %CollectibleCounter
@onready var timer_label : Label = %LevelTimer
@onready var fader: Fader = %Fader
@onready var level_complete: PanelContainer = %LevelCompleteContainer
@onready var stamp_revealer: AnimationPlayer = %StampRevealer
@onready var switch_button: TouchScreenButton = %SwitchButton
@onready var level_title: Label = %LevelTitle
@onready var level_title_shower: AnimationPlayer = %LevelTitleShower

var mobile_operating_systems = ["iOS", "Android"]

@warning_ignore_start("unused_signal")
signal fade_in_finished
signal fade_out_finished

func _ready() -> void:
	SignalBus.temple_available.connect(_show_stamp_notification)
	if GameController.temple_available_notified:
		_show_stamp_notification()
	visible = true
	if (OS.get_name() not in mobile_operating_systems) and not (OS.has_feature("web_ios") or OS.has_feature("web_android")): 
		switch_button.queue_free()
		


func _show_stamp_notification() -> void:
	stamp_revealer.play("reveal_stamp")

func _process(_delta: float) -> void:
	pass

func update_collectible_count(count: int) -> void:
	collectibles_label.text = str(count)


func update_time(time: float) -> void:
	timer_label.text = GlobalVars.float_to_time(time)


func show_level_end_screen(level_data: LevelData) -> void:
	level_complete.show_ui(level_data.collectibles_collected, level_data.time_spent)

func _on_fade_out_finished() -> void:
	SignalBus.fade_out_completed.emit()

func _on_fade_in_finished() -> void:
	SignalBus.fade_in_completed.emit()

func show_level_title(title: String) -> void:
	level_title.text = title
	level_title_shower.play(&"show_title")