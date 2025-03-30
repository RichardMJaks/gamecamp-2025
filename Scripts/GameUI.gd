extends CanvasLayer

@export var collectibles_label : Label
@export var timer_label : Label
@export var death_counter_label : Label
@export var level_complete_panel : Panel
@export var final_level_complete_panel : Panel

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
		collectibles_label.text = "Vibes: " + str(new_count) + " / " + str(total)

func _on_player_died(death_count):
	#death_counter_label.text = "Deaths: " + str(death_count)
	pass

func _on_level_completed(level_data):
	if level_complete_panel:
		# Show level complete panel
		level_complete_panel.visible = true
		
func _on_final_level_completed(levels_data):
	if final_level_complete_panel:
		for level_data in levels_data:
			
			pass
		# Show level complete panel
		print("show final level")
		final_level_complete_panel.visible = true
		
