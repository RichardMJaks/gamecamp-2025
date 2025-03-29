extends CanvasLayer

@export var game_controller : Node
@export var collectibles_label : Label
@export var timer_label : Label
@export var level_complete_panel : Panel

func _ready():	
	# Hide level complete panel initially
	level_complete_panel.visible = false

func _process(delta):
	# Update timer if level is active
	if game_controller and game_controller.is_level_active:
		update_timer(game_controller.level_time)

func update_timer(time):
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var msec = int((time - int(time)) * 100)
	timer_label.text = "%02d:%02d:%02d" % [minutes, seconds, msec]

func _on_collectible_collected(new_count):
	update_collectible_count_UI(new_count)
	
func update_collectible_count_UI(new_count):
	collectibles_label.text = "Vibes: " + str(new_count)

func _on_level_completed(time_taken, collectibles_count):
	# Show level complete panel
	level_complete_panel.visible = true
	
	# Update level complete info
	#$LevelCompletePanel/VBoxContainer/TimeValue.text = "Time: %s" % timer_label.text
	#$LevelCompletePanel/VBoxContainer/CollectiblesValue.text = "Collectibles: %d / %d" % [collectibles_count, game_controller.total_collectibles]
	
	#$LevelCompletePanel/VBoxContainer/StarsContainer.get_child(0).visible = stars >= 1
	#$LevelCompletePanel/VBoxContainer/StarsContainer.get_child(1).visible = stars >= 2
	#$LevelCompletePanel/VBoxContainer/StarsContainer.get_child(2).visible = stars >= 3
