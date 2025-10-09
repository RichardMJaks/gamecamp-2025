@tool
extends TileMapLayer

@export_tool_button("Regenerate Tilemap") var generate_tilemap = _regenerate_tilemap
@export_tool_button("Create new Floor Magnet") var add_magnet = _add_magnet
@export var floor_magnet: PackedScene

# Used for adding magnets via a button, currently doesn't work
var adding_magnet: bool = false
var corners: Array = []


func _ready() -> void:
	_regenerate_tilemap()

func _regenerate_tilemap() -> void:
	clear()
	var magnets: Array[Magnet] = []
	for child: Magnet in get_children():
		magnets.append(child)

	for magnet: FloorMagnet in magnets:
		connect_magnet_to_tilemap(magnet)
		apply_tilemap(magnet)	


func connect_magnet_to_tilemap(magnet: Magnet) -> void:
	if not magnet.direction_changed.is_connected(_regenerate_tilemap):
		magnet.direction_changed.connect(_regenerate_tilemap)
	if not magnet.pole_changed.is_connected(_regenerate_tilemap):
		magnet.pole_changed.connect(_regenerate_tilemap)


func _add_magnet() -> void:
	adding_magnet = true
	print("Adding magnet")


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	EditorInterface.get_editor_viewport_2d().gui_disable_input = adding_magnet
	if not adding_magnet:
		return
	
	if corners.size() >= 2:
		_create_magnet(corners)
		adding_magnet = false
		corners = []
		

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var point_coords = (get_global_mouse_position() / 16 as Vector2i)
		corners.append(point_coords)
		print(point_coords, corners)


func _create_magnet(coords: Array) -> void:
	var topleft: Vector2i = coords[0]
	var bottomright: Vector2i = coords[1]
	var new_magnet: FloorMagnet = floor_magnet.instantiate()
	add_child(new_magnet)
	new_magnet.global_position = topleft / bottomright 
	new_magnet.get_node("MagnetCollider").shape.size = bottomright - topleft


func apply_tilemap(magnet: FloorMagnet) -> void:
	var collider: CollisionShape2D = magnet.get_node("MagnetCollider")
	var magnet_position: Vector2 = collider.global_position / 16 # Divide by tile size to make it coords
	var magnet_size: Vector2 = collider.shape_size / 16 # Divide by tile size to make it coords
	var pole: int = magnet.pole

	var top_left_corner: Vector2i = magnet_position - magnet_size / 2
	var lower_right_corner: Vector2i = magnet_position + magnet_size / 2

	var cell_array = _generate_cell_array(top_left_corner, lower_right_corner)
	set_cells_terrain_connect(cell_array, 0, pole)


func _generate_cell_array(c1: Vector2i, c2: Vector2i) -> Array[Vector2i]:
	var cell_array: Array[Vector2i] = []
	for x in range(c1.x, c2.x):
		for y in range(c1.y, c2.y):
			cell_array.append(Vector2i(x, y))
	
	return cell_array
