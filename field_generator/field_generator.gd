extends Node2D

var tile_map_scane = load("res://level_1.tscn") as PackedScene
var field_scene = load("res://field_generator/field.tscn") as PackedScene
var map: TileMapLayer
var fields: Array[Area2D]
var field_size = 1.45 # multiple of tile size

func generate_collisions():
	map = tile_map_scane.instantiate()
	add_child(map)
	var cells = map.get_used_cells()

	for coord in cells:
		var charge = map.get_cell_tile_data(coord).get_custom_data("charge")
		if not charge: continue # not a magnet

		var field = field_scene.instantiate()
		field.strength = charge

		var shape = CollisionShape2D.new()
		shape.position = map.map_to_local(coord)
		print(coord, " -> ", map.map_to_local(coord))
		shape.shape = CircleShape2D.new()
		shape.shape.radius = map.tile_set.tile_size.x * field_size
		field.shape = shape
		field.add_child(shape)

		fields.append(field)
		add_child(field)

func _ready() -> void:
	generate_collisions()
