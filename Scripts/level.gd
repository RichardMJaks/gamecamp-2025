extends Node

@export var level_name: String = "Level1"
@export var player_node_path: NodePath
@export var level_end_area_path: NodePath

func _ready():
	# Initialize the level in the GameController
	GameController.initialize_level(level_name)
	
	# Connect level end area (finish line)
	var level_end_area = get_node(level_end_area_path)
	if level_end_area:
		level_end_area.body_entered.connect(_on_level_end_area_body_entered)

	# Connect UI signals
	var ui = $UI if has_node("UI") else null
	if ui:
		GameController.collectible_collected.connect(ui._on_collectible_collected)
		GameController.level_completed.connect(ui._on_level_completed)
		GameController.player_died.connect(ui._on_player_died)

func _on_level_end_area_body_entered(body):
	if body.is_in_group("player"):
		_on_level_complete()

func _on_level_complete():
	GameController.complete_level()
