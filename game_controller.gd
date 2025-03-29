extends Node

signal collectible_collected(new_count)
signal level_completed(time_taken, collectibles_count)

@export var game_ui : CanvasLayer

var collectibles_count: int = 0
var total_collectibles: int = 0
var level_start_time: float = 0
var level_time: float = 0
var is_level_active: bool = false

func _ready():
	# Count how many collectibles are in the level
	total_collectibles = get_tree().get_nodes_in_group("collectibles").size()
	print("Total collectibles in level: ", total_collectibles)
	
	# Start the level timer
	start_level()

func _process(delta):
	if is_level_active:
		# Update the level time
		level_time = Time.get_ticks_msec() / 1000.0 - level_start_time

func start_level():
	level_start_time = Time.get_ticks_msec() / 1000.0
	level_time = 0
	collectibles_count = 0
	is_level_active = true
	collectible_collected.emit(collectibles_count)

func collect_collectible():
	collectibles_count += 1
	#print('collectible count ' + str(collectibles_count))
	game_ui.update_collectible_count_UI(collectibles_count)
	collectible_collected.emit(collectibles_count)

func complete_level():
	is_level_active = false
	emit_signal("level_completed", level_time, collectibles_count)
	print("Level completed in %.2f seconds with %d/%d collectibles" % [level_time, collectibles_count, total_collectibles])
