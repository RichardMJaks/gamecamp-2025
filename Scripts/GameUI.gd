extends CanvasLayer

@export var collectibles_label : Label
@export var timer_label : Label
#@export var death_counter_label : Label
#@export var level_complete_panel : Panel

#Final level UI
@export var final_level_complete_panel : Panel
@export var level_stats_template: PackedScene
@export var final_level_stats_container : VBoxContainer

@export var final_total_stats_time : Label
@export var final_total_stats_collectibles : Label

func _process(delta):
	# Update timer if level is active
	if GameController and GameController.is_level_active:
		update_timer(GameController.levels_data[GameController.current_level_name].time_spent)

func update_timer(time):
	timer_label.text = GameController.format_time(time)

func _on_collectible_collected(new_count):
	update_collectible_count_UI(new_count)
	
func update_collectible_count_UI(new_count):
	if GameController and GameController.current_level_name != "":
		var total = GameController.levels_data[GameController.current_level_name].total_collectibles
		collectibles_label.text = "Nuts: " + str(new_count) + " / " + str(total)

func _on_player_died(death_count):
	#death_counter_label.text = "Deaths: " + str(death_count)
	pass

func _on_final_level_completed():
	if final_level_complete_panel:
		final_level_complete_panel.visible = true
		populate_level_stats()
		populate_total_stats()
		
func populate_level_stats():
	for level_name in GameController.levels_data.keys():
		var level_data = GameController.levels_data[level_name]
		# Create instance of level stats UI
		var level_stats = level_stats_template.instantiate()
		#print("Level Stats: ")
		#print(level_name)
		#print(GameController.format_time(level_data.time_spent))
		#print(str(level_data.death_count))
		#print(str(level_data.collectibles_count) + " / " + str(level_data.total_collectibles))
		# Set data
		level_stats.level_title.text = level_name + ": "
		level_stats.level_time.text = GameController.format_time(level_data.time_spent)
		#level_stats.get_node("DeathsValue").text = str(level_data.death_count)
		level_stats.level_collectibles.text = str(level_data.collectibles_count) + " / " + str(level_data.total_collectibles)
		
		# Add to container
		final_level_stats_container.add_child(level_stats)

func populate_total_stats():
	final_total_stats_time.text = "Time: " + str(GameController.format_time(GameController.get_total_time()))
	final_total_stats_collectibles.text = "Nuts: " + str(GameController.get_total_collectibles()[0]) + " / " + str(GameController.get_total_collectibles()[1])
	

func _on_main_menu_button_pressed() -> void:
	final_level_complete_panel.visible = false
	get_tree().paused = false
	GameController.reset()
	get_tree().change_scene_to_file("res://HUD/main_menu.tscn")
