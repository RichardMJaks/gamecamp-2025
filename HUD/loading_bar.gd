extends ProgressBar

@export var shader_loader: Node2D

func _ready() -> void:
	max_value = shader_loader.total_size
	min_value = 0
	value = 0

func _process(_delta):
	value = shader_loader.total_loaded