@tool
extends TileMapLayer

var cells: Dictionary = {
	"topleft": Vector2i(0,0),
	"topedge": Vector2i(1, 0),
	"topright": Vector2i(2, 0),
	"leftedge": Vector2i(0, 1),
	"center": Vector2i(1, 1),
	"rightedge": Vector2i(2, 1),
	"bottomleft": Vector2i(0, 2),
	"bottomedge": Vector2i(1, 2),
	"bottomright": Vector2i(2, 2)
}
var edge_names: Array = [
	"leftedge",
	"rightedge",
	"topedge",
	"bottomedge"
]
var corner_names: Array = [
	["topright", "bottomright"],
	["topleft", "bottomleft"],
	["bottomleft", "bottomright"],
	["topleft", "topright"],
]
var south_pole_x_offset: int = 3

@export_tool_button("Regenerate Tilemap") var generate_tilemap = _regenerate_tilemap

func _ready() -> void:
	_regenerate_tilemap()

func _regenerate_tilemap() -> void:
	clear()
	var magnets: Array[Magnet] = []
	for child: Magnet in get_children():
		magnets.append(child)

	for magnet in magnets:
		apply_tilemap(magnet)	


func apply_tilemap(magnet: FloorMagnet) -> void:
	var collider: CollisionShape2D = magnet.get_node("MagnetCollider")
	var magnet_position: Vector2 = collider.global_position / 16 # Divide by tile size to make it coords
	var magnet_size: Vector2 = collider.shape_size / 16 # Divide by tile size to make it coords
	var magnet_direction = magnet.magnet_direction
	# This is used to offset tilemap coords to match south pole coords in necessary 
	var tile_x_offset: int = south_pole_x_offset if magnet.pole == GlobalVars.POLE.SOUTH else 0

	var top_left_corner: Vector2i = magnet_position - magnet_size / 2
	# NOTE: The coords for bottom right corner are diagonally offset
	var lower_right_corner: Vector2i = magnet_position + magnet_size / 2 

	var corner_points = _get_corner_points(top_left_corner, lower_right_corner - Vector2i.ONE)

	_fill_solid(top_left_corner, lower_right_corner, tile_x_offset)
	_fill_edges(corner_points, magnet_direction, tile_x_offset)
	_fill_corners(corner_points, magnet_direction, tile_x_offset)


func _fill_solid(c_tl: Vector2i, c_lr: Vector2i, tile_x_offset: int) -> void:
	var tile_coords = _get_cell("center", tile_x_offset)

	for x in range(c_tl.x, c_lr.x):
		for y in range(c_tl.y, c_lr.y):
			set_cell(Vector2i(x, y), 0, tile_coords) 
	

func _fill_edges(corner_points: Array, dir: int, tile_x_offset: int) -> void:
	for i in range(4):
		if i == dir:
			continue

		var tile_coords: Vector2i = _get_cell(edge_names[i], tile_x_offset)
		var corners: Array = corner_points[i]

		# Vertical edge
		if corners[0].x == corners[1].x:
			var x = corners[0].x
			for y in range(corners[0].y, corners[1].y + 1):

				set_cell(Vector2i(x, y), 0, tile_coords)
		# Horizontal edge
		elif corners[0].y == corners[1].y:
			var y = corners[0].y
			for x in range(corners[0].x, corners[1].x + 1):
				set_cell(Vector2i(x, y), 0, tile_coords)
		#TODO: Implement single-cell thickness magnet tiles
		else:
			push_error("Magnets cannot be single cell sized yet")


func _fill_corners(corner_points: Array, dir: int, tile_x_offset: int) -> void:
	var reversed_corner_points = corner_points.duplicate()
	reversed_corner_points[0] = corner_points[1]
	reversed_corner_points[1] = corner_points[0]
	reversed_corner_points[2] = corner_points[3]
	reversed_corner_points[3] = corner_points[2]

	var tile_coords: Array = [
		_get_cell(corner_names[dir][0], tile_x_offset),
		_get_cell(corner_names[dir][1], tile_x_offset),
	]

	var corners: Array = reversed_corner_points[dir]

	set_cell(corners[0], 0, tile_coords[0])
	set_cell(corners[1], 0, tile_coords[1])
	#TODO: Implement single-cell thickness magnet tiles


func _get_corner_points(corner_topleft: Vector2i, corner_lowerright: Vector2i) -> Array:
	var edges: Array = [
		[ # Left edge
			Vector2(corner_topleft.x, corner_topleft.y), 
			Vector2(corner_topleft.x, corner_lowerright.y)
		],
		[ # Right Edge
			Vector2(corner_lowerright.x, corner_topleft.y), 
			Vector2(corner_lowerright.x, corner_lowerright.y)
		],
		[ # Top Edge
			Vector2(corner_topleft.x, corner_topleft.y), 
			Vector2(corner_lowerright.x, corner_topleft.y)
		],
		[ # Bottom Edge
			Vector2(corner_topleft.x, corner_lowerright.y), 
			Vector2(corner_lowerright.x, corner_lowerright.y)
		],
	]

	return edges


func _get_cell(cell_name: String, x_offset: int) -> Vector2i:
	var cell = cells[cell_name]
	cell.x += x_offset

	return cell

