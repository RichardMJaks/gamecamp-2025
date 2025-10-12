extends Node2D

@export var start_gate: Node2D
@export var end_gate: Node2D
@export var next_level: PackedScene

var collectibles_count: int = 0
var time_spent: float = 0

@onready var ui: UI = %UI

func _ready() -> void:
	SignalBus.level_completed.connect(_on_level_completed)	
	SignalBus.fade_in_completed.connect(_spawn_player)


func _process(delta: float) -> void:
	if GameController.timing:
		time_spent += delta


func _create_level_data() -> LevelData:
	var level_data = LevelData.new()

	level_data.time_spent = time_spent
	level_data.collectibles_collected = collectibles_count

	return level_data


func _on_collectible_collected() -> void:
	collectibles_count += 1
	ui.update_collectible_count(collectibles_count)


func _on_level_completed() -> void:
	var level_data = _create_level_data()
	_show_level_end_screen(level_data)


func _spawn_player() -> void:
	start_gate.spawn_player()


func _show_level_end_screen(level_data: LevelData) -> void:
	ui.show_level_end_screen()


func _goto_next_level() -> void:
	if not next_level:
		print_debug("Next level not configured, assume game completion")
		SignalBus.session_completed.emit()
		return

	GameController.goto_level(next_level)	
