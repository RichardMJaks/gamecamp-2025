extends Node

signal collectible_collected(new_count)
signal final_level_completed(levels_data)
signal level_completed(level_data)
signal player_died(death_count)

# Dictionary to store level data
var levels_data = {}
var current_level_name = ""
var current_level_index = 0
var total_levels = 0

# Array of level scene paths in order
var level_scenes = [
	"res://levels/level_0.tscn",
	"res://levels/level_1.tscn",
	"res://levels/level_2.tscn",
	"res://levels/level_3.tscn",
	"res://levels/level_4.tscn",
]

var is_level_active = false

func _ready():
	total_levels = level_scenes.size()

func _process(delta):
	if is_level_active and current_level_name != "":
		# Update the level time
		var current_data = levels_data[current_level_name]
		current_data.time_spent += delta
		levels_data[current_level_name] = current_data

func initialize_level(level_name):
	current_level_name = level_name
	is_level_active = true
	
	# Create level data if it doesn't exist
	if not levels_data.has(level_name):
		levels_data[level_name] = {
			"time_spent": 0.0,
			"collectibles_count": 0,
			"total_collectibles": 0,
			"death_count": 0,
			"completed": false
		}
	
	# Count collectibles
	await get_tree().process_frame
	var collectibles = get_tree().get_nodes_in_group("collectibles")
	levels_data[current_level_name].total_collectibles = collectibles.size()
	
	# Emit collectible signal to update UI
	collectible_collected.emit(levels_data[current_level_name].collectibles_count)
	
	print("Level initialized: ", level_name)
	print("Collectibles in level: ", levels_data[current_level_name].total_collectibles)

func collect_collectible():
	if current_level_name != "":
		levels_data[current_level_name].collectibles_count += 1
		collectible_collected.emit(levels_data[current_level_name].collectibles_count)

func handle_player_died():
	if current_level_name != "":
		levels_data[current_level_name].death_count += 1
		player_died.emit(levels_data[current_level_name].death_count)
		reset_all_collectibles()

func complete_level():
	if current_level_name != "":
		is_level_active = false
		levels_data[current_level_name].completed = true
		emit_signal("level_completed", levels_data[current_level_name])
		
		print("Level completed: ", current_level_name)
		print("Time: ", format_time(levels_data[current_level_name].time_spent))
		print("Collectibles: ", levels_data[current_level_name].collectibles_count, "/", levels_data[current_level_name].total_collectibles)
		print("Deaths: ", levels_data[current_level_name].death_count)
		go_to_next_level()

func go_to_next_level():
	current_level_index += 1
	if current_level_index < total_levels:
		# Load next level
		get_tree().change_scene_to_file(level_scenes[current_level_index])
	else:
		get_tree().change_scene_to_file("res://HUD/main_menu.tscn")
		# No more levels, show end screen
		show_end_screen()

func restart_current_level():
	# This function is no longer needed for in-level deaths
	# It's kept for manual restarts or level transitions
	get_tree().reload_current_scene()

func show_end_screen():
	# Display end screen
	print("levels_data")
	emit_signal("final_level_completed")

func get_total_time():
	var total = 0.0
	for level_name in levels_data:
		print(levels_data[level_name])
		total += levels_data[level_name].time_spent
	return total

func get_total_deaths():
	var total = 0
	for level_name in levels_data:
		total += levels_data[level_name].death_count
	return total

func get_total_collectibles():
	var collected = 0
	var total = 0
	for level_name in levels_data:
		collected += levels_data[level_name].collectibles_count
		total += levels_data[level_name].total_collectibles
	return [collected, total]

func format_time(time_in_seconds):
	@warning_ignore("integer_division")
	var minutes = int(time_in_seconds) / 60
	var seconds = int(time_in_seconds) % 60
	var msec = int((time_in_seconds - int(time_in_seconds)) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds, msec]

func reset_all_collectibles():
	var collectibles = get_tree().get_nodes_in_group("collectibles")
	for collectible in collectibles:
		collectible.reset()
