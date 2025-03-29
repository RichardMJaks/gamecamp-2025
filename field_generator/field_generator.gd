extends Node2D

var tile_map_scane = load("res://field_generator/tile_map_layer.tscn") as PackedScene
var field_scene = load("res://field_generator/field.tscn") as PackedScene

var map: TileMapLayer
var fields: Array[Area2D]
var debug_arrows: Array[Line2D]

# returns {tile coord -> force vector}
func find_forces() -> Dictionary:
	map = tile_map_scane.instantiate()
	add_child(map)

	var forces = {}
	var cells = map.get_used_cells()
	for transmitter in cells:
		var force = map.get_cell_tile_data(transmitter).get_custom_data("force")
		if not force:
			continue # transmitter is not a magnet

		var surrunding = map.get_surrounding_cells(transmitter)
		for s in surrunding:
			if s in cells:
				continue

			if not s in forces:
				forces[s] = force
			else:
				forces[s] += force
	return forces

func generate_collisions(forces: Dictionary):
	for coord in forces:
		var force = forces[coord]
		var local_coord = map.map_to_local(coord)
		var tile_size = map.tile_set.tile_size
		var field = field_scene.instantiate()
		field.force = force

		var shape = CollisionShape2D.new()
		shape.position = local_coord
		shape.shape = RectangleShape2D.new()
		shape.shape.size = tile_size
		field.add_child(shape)
		
		fields.append(field)
		add_child(field)
		
		## debug ########################################
		var arrow = Line2D.new()
		arrow.add_point(Vector2(0,0))
		arrow.add_point(Vector2(0,0) + force * 20)
		arrow.width = 2
		var gradient = Gradient.new()
		gradient.set_color(0, Color(1, 0, 0))
		gradient.set_color(1, Color(0, 0, 1))
		arrow.gradient = gradient

		shape.add_child(arrow)
		#################################################

func _ready() -> void:
	var forces = find_forces()
	generate_collisions(forces)
