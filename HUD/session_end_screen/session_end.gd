extends Control

@export var stats_container: PackedScene

@onready var stats_box: Control = %StatsContainer
@onready var total_stats: Control = %TotalStats 
@onready var btn_mainmenu: Button = %MainMenuButton


func _input(event: InputEvent) -> void:
	if event.is_action_released(&"ui_accept"):
		_restart_session()

	# Check for any directional input before grabbing focus to button
	if event.is_action(&"ui_up") or event.is_action(&"ui_down"):
		btn_mainmenu.grab_focus()


func _ready() -> void:
	var levels_data: Array[LevelData] = GameController.levels_data
	populate_stats(levels_data)

	total_stats.initialize("TOTAL", GameController.total_time_spent, GameController.total_collectables_collected)
	
	BgMusic.play_music(BgMusic.MusicType.END)


func populate_stats(levels_data: Array[LevelData]) -> void:
	_populate_level_stats(levels_data)


func _populate_level_stats(levels_data: Array[LevelData]) -> void:
	total_stats.modulate.a = 0
	for i in range(levels_data.size()):
		var level_title: String = "%02d" % [i + 1]

		var data: LevelData = levels_data[i]
		var time: float = data.time_spent
		var collectibles: int = data.collectibles_collected

		var stats_row: Control = _create_level_stats_container(level_title, time, collectibles)

		@warning_ignore("confusable_local_declaration")
		var stats_tween: Tween = stats_row.create_tween()
		stats_tween.tween_property(stats_row, ^"modulate:a", 1, 3).set_delay(i * 1 + 2)
		stats_tween.tween_callback(func(): print_debug(stats_row.modulate.a))
		
	var stats_tween: Tween = total_stats.create_tween()
	stats_tween.tween_property(total_stats, ^"modulate:a", 1, 3).set_delay(levels_data.size() * 1 + 2)


func _create_level_stats_container(level_title: String, time: float, collectibles: int) -> Control:
	var container: Control = stats_container.instantiate()
	container.initialize(level_title, time, collectibles)
	container.modulate.a = 0
	stats_box.add_child(container)
	
	return container


func _on_main_menu_button_pressed() -> void:
	_restart_session()


func _restart_session() -> void:
	SignalBus.session_restarted.emit()
