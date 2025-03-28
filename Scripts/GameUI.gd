extends CanvasLayer

@export var collectibles_label : Label
@export var timer_label : Label
@export var death_counter_label : Label
@export var level_complete_panel : Panel

func _ready():
	# Hide level complete panel initially
	level_complete_panel.visible = false

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
	# Show level complete panel
	level_complete_panel.visible = true
	
	# Update level complete info
	#$LevelCompletePanel/VBoxContainer/TimeValue.text = "Time: %s" % GameController.format_time(level_data.time_spent)
	#$LevelCompletePanel/VBoxContainer/CollectiblesValue.text = "Collectibles: %d / %d" % [level_data.collectibles_count, level_data.total_collectibles]
	#$LevelCompletePanel/VBoxContainer/DeathsValue.text = "Deaths: %d" % level_data.death_count
	
	# Auto-proceed to next level after a delay
	await get_tree().create_timer(1.0).timeout
	level_complete_panel.visible = false
	GameController.go_to_next_level()
