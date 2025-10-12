extends Node

var current_scene: Node = null
var next_level: PackedScene = null
var levels_data: Array[LevelData] = []
var timing: bool = false
var total_time_spent: float = 0
var total_collectables_collected: int = 0

#TODO: Implement session end screen
@onready var session_end_screen: PackedScene = preload("res://HUD/session_end_screen/session_end.tscn")
@onready var main_menu: PackedScene = preload("res://HUD/main_menu.tscn")

func _ready() -> void:
	SignalBus.timing_started.connect(_on_timing_started)
	SignalBus.timing_stopped.connect(_on_timing_stopped)
	SignalBus.session_completed.connect(_on_session_completed)
	SignalBus.session_restarted.connect(_on_session_restart)
	SignalBus.collectible_collected.connect(_update_total_collectibles)


func _process(delta: float) -> void:
	if timing:
		total_time_spent += delta


func _on_timing_started() -> void:
	timing = true


func _on_timing_stopped() -> void:
	timing = false


func _update_total_collectibles() -> void:
	total_collectables_collected += 1


func goto_level(level: PackedScene) -> void:
	next_level = level

	if not current_scene:
		_initialize_next_level()
		return
		
	SignalBus.start_fade_out.emit()


func add_level_data(level_data: LevelData) -> void:
	levels_data.append(level_data)


func _on_session_completed() -> void:
	_show_end_screen()


func _on_session_restart() -> void:
	_reset_stats()
	get_tree().change_scene_to_packed(main_menu)

func _reset_stats() -> void:
	total_collectables_collected = 0
	total_time_spent = 0
	levels_data = []

func _show_end_screen() -> void:
	if not session_end_screen:
		push_error("Session end screen not configured!")
		return

	get_tree().change_scene_to_packed(session_end_screen)
	

func _initialize_next_level() -> void:
	get_tree().change_scene_to_packed(next_level)