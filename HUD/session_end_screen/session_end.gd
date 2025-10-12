extends Control

@export var stats_container: PackedScene

var total_time: float = 0
var total_collectibles: int = 0

@onready var stats_box: Control = %StatsContainer
@onready var total_stats: Control = %TotalStats 

func _ready() -> void:
	var levels_data: Array[LevelData] = GameController.levels_data
	populate_stats(levels_data)

	total_stats.initialize("TOTAL", total_time, total_collectibles)


func populate_stats(levels_data: Array[LevelData]) -> void:
	_populate_level_stats(levels_data)


func _populate_level_stats(levels_data: Array[LevelData]) -> void:
	for i in range(levels_data.size()):
		var level_title: String = "%02d" % [i + 1]

		var data: LevelData = levels_data[i]
		var time: float = data.time_spent
		var collectibles: int = data.collectibles_collected

		total_time += time
		total_collectibles += collectibles

		_create_level_stats_container(level_title, time, collectibles)


func _create_level_stats_container(level_title: String, time: float, collectibles: int) -> void:
	var container = stats_container.instantiate()
	container.initialize(level_title, time, collectibles)
	stats_box.add_child(container)
