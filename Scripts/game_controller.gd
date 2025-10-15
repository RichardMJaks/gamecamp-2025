extends Node

var current_scene: Node = null
var next_level: PackedScene = null
var levels_data: Array[LevelData] = []
var timing: bool = false
var total_time_spent: float = 0
var total_collectables_collected: int = 0
var temple_available_notified: bool = false
var admin_reset_session_available: bool = false
var hack_enabling_available: bool = false
var hack_enabled: bool = false
var mobile_joystick: Node = null

@onready var can_admin: bool = OS.has_feature("admin")
@onready var expo_build: bool = OS.has_feature("expo")

#TODO: Implement session end screen
@onready var session_end_screen: PackedScene = preload("res://HUD/session_end_screen/session_end.tscn")
@onready var main_menu: PackedScene = preload("res://HUD/main_menu.tscn")

func _input(event: InputEvent) -> void:
	if not can_admin:
		return
		
	_handle_reset_session_admin_command(event)
	_handle_hacks_enabling_admin_command(event)

	if hack_enabled:
		_handle_hacks_admin_command(event)

func _handle_hacks_admin_command(event: InputEvent) -> void:
	if event.is_action_released(&"admin_clear_level"):
		SignalBus.level_completed.emit()
		AdminPanel.send_temp_message("Won level", 5)



func _handle_hacks_enabling_admin_command(event: InputEvent) -> void:
	if event.is_action_pressed(&"admin_hacks"):
		hack_enabling_available = true
	if event.is_action_released(&"admin_hacks"):
		hack_enabling_available = false
	if event.is_action_released(&"admin_config") and hack_enabling_available:
		hack_enabled = not hack_enabled
		if hack_enabled:
			AdminPanel.send_perm_message("HACKS ENABLED", "hacks_enabled")
		else:
			AdminPanel.remove_perm_message("hacks_enabled")

func _handle_reset_session_admin_command(event: InputEvent) -> void:
	if event.is_action_pressed(&"admin_reset_session"):
		admin_reset_session_available = true
	if event.is_action_released(&"admin_reset_session"):
		admin_reset_session_available = false
	if event.is_action(&"admin_config") and admin_reset_session_available:
		SignalBus.session_restarted.emit()
		AdminPanel.send_temp_message("SESSION RESTARTED", 5)


func _ready() -> void:
	SignalBus.timing_started.connect(_on_timing_started)
	SignalBus.timing_stopped.connect(_on_timing_stopped)
	SignalBus.session_completed.connect(_on_session_completed)
	SignalBus.session_restarted.connect(_on_session_restart)
	SignalBus.collectible_collected.connect(_update_total_collectibles)


func _process(delta: float) -> void:
	if timing:
		total_time_spent += delta
	
	if expo_build and not temple_available_notified and total_collectables_collected >= 3:
		_notify_temple_available()


func _notify_temple_available() -> void:
	SignalBus.temple_available.emit()
	temple_available_notified = true


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
	temple_available_notified = false
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
