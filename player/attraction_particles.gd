extends GPUParticles2D

@onready var player: Player = owner
@export_range(0, 360, 1) var north_hue: float = 255:
	get:
		return north_hue / 360
@export_range(0, 360, 1) var south_hue: float = 358:
	get:
		return south_hue / 360

func _process(_delta: float) -> void:
	process_material.direction.x = -player.up_direction.x
	process_material.direction.y = -player.up_direction.y

	if player.current_magnet:
		emitting = true
		var gradient: Gradient = texture.gradient
		var colors: PackedColorArray = gradient.colors
		var c_1: Color = colors[0]
		var c_2: Color = colors[1]
		var color_hue: float = 255.0 / 360 if player.current_pole == GlobalVars.POLE.NORTH else 358.0 / 360.0
		c_1.h = color_hue
		c_2.h = color_hue 
		gradient.set_color(0, c_1)
		gradient.set_color(1, c_2)
	else:
		emitting = false
