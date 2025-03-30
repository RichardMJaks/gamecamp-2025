extends Control

@export var level_stats_container: VBoxContainer
@export var level_stats_template: PackedScene
@export var total_stats_time : Label
@export var total_stats_collectibles : Label

func _ready():
	# Populate level statistics
	populate_level_stats()
	
	# Set total statistics
	total_stats_time.text = GameController.format_time(GameController.get_total_time())
	
	var collectibles = GameController.get_total_collectibles()
	total_stats_collectibles.text = str(collectibles[0]) + " / " + str(collectibles[1])

func populate_level_stats():
	for level_name in GameController.levels_data.keys():
		var level_data = GameController.levels_data[level_name]
		
		# Create instance of level stats UI
		var level_stats = level_stats_template.instantiate()
		
		# Set data
		level_stats.get_node("HBoxContainer/LevelNameLabel").text = level_name
		level_stats.get_node("HBoxContainer/VBoxContainer/TimeValueLabel").text = GameController.format_time(level_data.time_spent)
		#level_stats.get_node("DeathsValue").text = str(level_data.death_count)
		level_stats.get_node("HBoxContainer/VBoxContainer/CollectiblesValueLabel").text = str(level_data.collectibles_count) + " / " + str(level_data.total_collectibles)
		
		# Add to container
		level_stats_container.add_child(level_stats)
